import {initAudioCapture} from './sensors/audio'
import {Config} from './types/config'
import {Logger} from './types/sensor'

export const listen = async (config: Config, logger: Logger) => {
  const sensorTypes = Object.keys(config.sensors)
  const sensors = await Promise.all(
    sensorTypes.map(type => {
      switch (type) {
        case 'audio':
          return initAudioCapture(config, logger)
        default: {
          throw new Error(`${type} doesn't have an implementation yet`)
        }
      }
    })
  )

  const data = await Promise.all(sensors.map(sensor => sensor.captureData()))

  console.log(data)
  return data
}
