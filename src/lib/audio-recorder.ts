import {spawn, SpawnOptions} from 'child_process'
import {EventEmitter} from 'events'
import {Readable} from 'stream'

type Logger = {
  log: (message: string) => void
  warn: (message: string) => void
  error: (message: string) => void
}

type Options = {
  program: 'rec' | 'arecord' | 'sox' // Which program to use, either `arecord`, `rec`, and `sox`.
  device?: string // Recording device to use.
  driver?: string // Recording driver to use.

  bits: number // Sample size. (only for `rec` and `sox`)
  channels: number // Channel count.
  encoding: 'signed-integer' // Encoding type. (only for `rec` and `sox`)
  format: 'S16_LE' // Format type. (only for `arecord`)
  rate: number // Sample rate.
  type: 'wav' // File type.
  duration?: number // Only implemented for 'arecord' so far

  // Following options only available when using `rec` or `sox`.
  silence: number // Duration of silence in seconds before it stops recording.
  thresholdStart: number // Silence threshold to start recording.
  thresholdStop: number // Silence threshold to stop recording.
  keepSilence: boolean // Keep the silence in the recording.
}

class AudioRecorder extends EventEmitter {
  /**
   * Constructor of AudioRecord class.
   * @param {Object} options Object with optional options variables
   * @param {Object} logger Object with log, warn, and error functions
   * @returns {AudioRecorder} this
   */

  private _options: Options
  private _logger: Logger
  private _childProcess: ReturnType<typeof spawn> | undefined
  private _command: {
    arguments: string[]
    options: SpawnOptions
  }

  constructor(options: Partial<Options>, logger: Logger) {
    super()

    // For the `rec` and `sox` only options the default is applied if a more general option is not specified.
    this._options = {
      program: 'rec', // Which program to use, either `arecord`, `rec`, and `sox`.

      bits: 16, // Sample size. (only for `rec` and `sox`)
      channels: 1, // Channel count.
      encoding: 'signed-integer', // Encoding type. (only for `rec` and `sox`)
      format: 'S16_LE', // Format type. (only for `arecord`)
      rate: 16000, // Sample rate.
      type: 'wav', // File type.

      // Following options only available when using `rec` or `sox`.
      silence: 2, // Duration of silence in seconds before it stops recording.
      thresholdStart: 0.5, // Silence threshold to start recording.
      thresholdStop: 0.5, // Silence threshold to stop recording.
      keepSilence: true, // Keep the silence in the recording.

      ...options
    }

    this._logger = logger

    this._command = {
      arguments: [
        // Show no progress
        '-q',
        // Channel count
        '-c',
        this._options.channels.toString(),
        // Sample rate
        '-r',
        this._options.rate.toString(),
        // Format type
        '-t',
        this._options.type
      ],
      options: {
        // encoding: 'binary',
        env: Object.assign({}, process.env)
      }
    }

    switch (this._options.program) {
      default:
      case 'sox':
        this._command.arguments.unshift('-d')
      case 'rec':
        // Add sample size and encoding type.
        this._command.arguments.push(
          // Show no error messages
          //   Use the `close` event to listen for an exit code.
          '-V0',
          // Endian
          //   -L = little
          //   -B = big
          //   -X = swap
          '-L',
          // Bit rate
          '-b',
          this._options.bits.toString(),
          // Encoding type
          '-e',
          this._options.encoding,
          // Pipe
          '-'
        )

        if (this._options.silence) {
          this._command.arguments.push(
            // Effect
            'silence'
          )

          // Keep the silence of the recording.
          if (this._options.keepSilence) {
            this._command.arguments.push(
              // Keep silence in results
              '-l'
            )
          }

          // Stop recording after duration has passed below threshold.
          this._command.arguments.push(
            // Enable above-periods
            '1',
            // Duration
            '0.1',
            // Starting threshold
            this._options.thresholdStart.toFixed(1).concat('%'),
            // Enable below-periods
            '1',
            // Duration
            this._options.silence.toFixed(1),
            // Stopping threshold
            this._options.thresholdStop.toFixed(1).concat('%')
          )
        }

        // Setup environment variables.
        if (this._options.device && this._command.options.env) {
          this._command.options.env.AUDIODEV = this._options.device
        }
        if (this._options.driver && this._command.options.env) {
          this._command.options.env.AUDIODRIVER = this._options.driver
        }
        break

      case 'arecord':
        if (this._options.device) {
          this._command.arguments.unshift('-D', this._options.device)
        }
        this._command.arguments.push(
          // Format type
          '--format',
          'S16_LE'
        )
        if (this._options.duration) {
          this._command.arguments.push(
            '--duration',
            this._options.duration.toString()
          )
        }
        break
    }

    if (this._logger) {
      // Log command.
      this._logger.log(
        `AudioRecorder: Command '${
          this._options.program
        } ${this._command.arguments.join(' ')}'; Options: AUDIODEV ${
          this._command.options.env?.AUDIODEV
            ? this._command.options.env.AUDIODEV
            : '(default)'
        }, AUDIODRIVER: ${
          this._command.options.env?.AUDIODRIVER
            ? this._command.options.env.AUDIODRIVER
            : '(default)'
        };`
      )
    }

    return this
  }
  /**
   * Creates and starts the audio recording process.
   * @returns {AudioRecorder} this
   */
  start(): AudioRecorder {
    if (this._childProcess) {
      if (this._logger) {
        this._logger.warn(
          'AudioRecorder: Process already active, killed old one started new process.'
        )
      }
      this._childProcess.kill()
    }

    // Create new child process and give the recording commands.
    this._childProcess = spawn(
      this._options.program,
      this._command.arguments,
      this._command.options
    )

    // Store this in `self` so it can be accessed in the callback.
    let self = this
    this._childProcess.on('close', exitCode => {
      if (self._logger) {
        self._logger.log(`AudioRecorder: Exit code '${exitCode}'.`)
      }
      self.emit('close', exitCode)
    })
    this._childProcess.on('error', error => {
      self.emit('error', error)
    })
    this._childProcess.on('end', () => {
      self.emit('end')
    })

    if (this._logger) {
      this._logger.log('AudioRecorder: Started recording.')
    }

    return this
  }
  /**
   * Stops and removes the audio recording process.
   */

  stop(): AudioRecorder {
    if (!this._childProcess) {
      if (this._logger) {
        this._logger.warn(
          'AudioRecorder: Unable to stop recording, no process active.'
        )
      }
      return this
    }

    this._childProcess.kill()
    this._childProcess = undefined

    if (this._logger) {
      this._logger.log('AudioRecorder: Stopped recording.')
    }

    return this
  }

  /**
   * Get the audio stream of the recording process.
   */
  stream(): Readable | null {
    if (!this._childProcess) {
      const message =
        'AudioRecorder: Unable to retrieve stream, because no process not active. Call the start or resume function first.'
      if (this._logger) {
        this._logger.warn(message)
      }
      throw new Error(message)
    }

    return this._childProcess.stdout
  }
}

export default AudioRecorder
