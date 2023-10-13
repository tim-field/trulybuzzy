const cheerio = require('cheerio')

const url = 'https://avibase.bsc-eoc.org/checklist.jsp?region=NZct'

fetch(url)
  .then(response => response.text())
  .then(html => {
    const $ = cheerio.load(html)
    const birds = $('table.table tbody tr.highlight1').toArray()
    const birdList = birds
      .map(bird => {
        const scientificName = $(bird).find('td:nth-child(2)').text().trim()
        const commonName = $(bird).find('td:nth-child(1)').text().trim()
        return `${scientificName}_${commonName}`
      })
      .sort()
    console.log(birdList.join('\n'))
  })
  .catch(error => console.error(error))
