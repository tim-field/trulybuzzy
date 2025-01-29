# trulybuzzy

Record birdsong at sunrise

www.mohiohio.com

## Execution Flow

- crontab@reboot
  - [update.sh](./update.sh) -> [schedule.sh](./schedule.sh) schedules run.sh at sunrise
- crontab@sunrise
  - [run.sh](./run.sh)
    - [upload.sh](./upload.sh)
    - [watch.sh](./watch.sh)
    - [listen.sh](./listen.sh)

#### [update.sh](./update.sh)

- Performs a git pull
- Installs cron.crontab
- Calls **./schedule.sh**
- Disables USB ( saving power )

#### [schedule.sh](./schedule.sh)

- Determines sunrise time via an API call
- Schedules **run.sh** to run at sunrise by updating crontab

#### [run.sh](./run.sh)

- Enables USB
- Runs the following in parallel
  - **[upload.sh](./upload.sh)**: uploads any files that failed to transfer in the)
  - **[watch.sh](./watch.sh)**: records and uploads video
  - **[listen.sh](./listen.sh)**: records and uploads audio
- Shuts down the system
