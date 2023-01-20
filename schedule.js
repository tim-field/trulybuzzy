const schedule = require('node-schedule')
const {exec} = require('child_process')

const usbOn = () =>
  new Promise((resolve, reject) =>
    exec('./usb-on.sh', (error, stdout, stderr) => {
      if (error) {
        console.error(stderr)
        return reject(error)
      }
      return resolve(stdout)
    })
  )

const usbOff = () =>
  new Promise((resolve, reject) =>
    exec('./usb-off.sh', (error, stdout, stderr) => {
      if (error) {
        console.error(stderr)
        return reject(error)
      }
      return resolve(stdout)
    })
  )

// https://sunrise-sunset.org/api
const getDawnDusk = async (when, lat, lng) => {
  try {
    const output = await usbOn()
    console.log(output)
  } catch (e) {
    console.log('Unable to start usb')
  }

  resp = await fetch(
    `https://api.sunrise-sunset.org/json?lat=${lat}&lng=${lng}&formatted=0&date=${when}`
  )

  try {
    const output = await usbOff()
    console.log(output)
  } catch (e) {
    console.log('Unable to switch off usb')
  }

  if (!resp.ok) {
    console.error({
      status: resp.status,
      body: resp.text()
    })
    throw new Error('Error status from sunrise-sunset.org')
  }

  const data = await resp.json()
  if (data.status !== 'OK') {
    throw new Error('Error response from sunrise-sunset.org')
  }

  const dawn = new Date(data.results.nautical_twilight_begin)
  const dusk = new Date(data.results.sunset)
  // console.log(dawn.toLocaleString('en-AU', {timeZone: 'Pacific/Auckland'}))
  // console.log(dusk.toLocaleString('en-AU', {timeZone: 'Pacific/Auckland'}))

  return [dawn, dusk]
}

const run = async (lat, lng) => {
  const [dawn, dusk] = await getDawnDusk(
    'tomorrow',
    lat ?? '-45.8787605',
    lng ?? '170.5027976'
  )

  const dawnJob = schedule.scheduleJob(dawn, () => {
    exec('./test.sh 14400', (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`)
        return
      }
      console.log(`stdout: ${stdout}`)
      console.error(`stderr: ${stderr}`)
    })
  })

  const duskJob = schedule.scheduleJob(dusk, () => {
    exec('./test.sh 3600', (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`)
        return
      }
      console.log(`stdout: ${stdout}`)
      console.error(`stderr: ${stderr}`)
    })
    run()
  })

  return [dawnJob, duskJob]
}

run().then(([dawn, dusk]) => {
  console.log(
    'Jobs scheduled for ',
    dawn
      .nextInvocation()
      .toLocaleString('en-AU', {timeZone: 'Pacific/Auckland'}),
    dusk
      .nextInvocation()
      .toLocaleString('en-AU', {timeZone: 'Pacific/Auckland'})
  )
})
