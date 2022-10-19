import {Config} from './config'

export type Logger = {
  log: (message: string) => void
  info: (message: string) => void
  warn: (message: string) => void
  error: (message: string) => void
}

export type Sensor = {
  setup: () => Promise<void> | void
  captureData: () => Promise<string> | string
  postProcess: (path: string) => Promise<string> | string
}

export type InitSensor = (config: Config, logger: Logger) => Sensor
