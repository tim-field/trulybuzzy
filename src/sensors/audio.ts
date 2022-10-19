import AudioRecorder from '../lib/audio-recorder'
import {InitSensor} from '../types/sensor'
import * as path from 'path'
import {createWriteStream} from 'fs'
import {pipeline} from 'stream'
import {promisify} from 'util'

export const initAudioCapture: InitSensor = (config, logger) => {
  return {
    setup() {},
    async captureData() {
      const audioConfig = config.sensors.audio
      if (!audioConfig) {
        throw new Error(`No audio config present`)
      }

      // Name files by start time and duration
      const now = new Date()
      const startTime = `${now.getHours()}-${now.getMinutes()}-${now.getSeconds()}`

      const currentFile = `${startTime}_dur${audioConfig.recordLength}secs.wav`

      // Record for a specific duration
      logger.info(`\n${currentFile} - Started recording\n`)
      const outputFilePath = path.join(config.sys.workingDir, currentFile)
      //  const cmd = `sudo arecord --device hw:1,0 --rate 44100 --format S16_LE --duration {} {}`
      const audioRecorder = new AudioRecorder(
        {
          program: 'arecord',
          silence: 0,
          device: 'hw:1,0',
          rate: 44100,
          duration: audioConfig.recordLength
        },
        logger
      )
      // Create write stream.
      const fileStream = createWriteStream(outputFilePath, {
        encoding: 'binary'
      })

      const audioStream = audioRecorder.start().stream()

      if (!audioStream) {
        throw new Error('No audio stream avialable')
      }

      const pipelinePromise = promisify(pipeline)
      try {
        await pipelinePromise(audioStream, fileStream)

        logger.info(`\n${currentFile} - Finished recording\n`)
        return outputFilePath
      } catch (err) {
        logger.error('Error recording from audio card ')
        logger.error(String(err))
        throw err
      }
    },
    async postProcess() {
      return 'todo'
    }
  }
}
