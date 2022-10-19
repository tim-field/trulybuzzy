type SensorTimeLapseConfig = {
  device: string
  type: 'time_lapse_camera'
  captureDelay: number
}

type SensorAudioConfig = {
  caputreDelay?: number
  recordLength: number
  compressData?: boolean
}

// type SensorConfig = SensorTimeLapseConfig | SensorAudioConfig

export type Config = {
  sys: {
    uploadDir?: string
    workingDir: string
  }
  ftp?: {}
  sensors: {
    audio?: SensorAudioConfig
    camera?: SensorTimeLapseConfig
  }
}

/*


{
    "sys": {
        "upload_dir": "/home/tim/continuous_monitoring_data",
        "working_dir": "/home/tim/tmp_dir",
        "reboot_time": "02:00"
    },
    "ftp": {},
    "sensor": {
        "device": "/dev/video0",
        "sensor_type": "TimelapseCamera",
        "capture_delay": 86400.0,
        "sensor_index": 1
    },
    "offline_mode": 1
}

*/
