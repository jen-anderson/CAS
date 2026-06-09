import fs from 'fs'
import path from 'path'

const dir = './lib/_handlers'
const files = fs.readdirSync(dir)

files.forEach(file => {
  if (file === 'index.ts') return // Skip index
  const filePath = path.join(dir, file)
  const content = fs.readFileSync(filePath, 'utf8')

  // Get the model name from the filename (e.g., 'solvent.ts' -> 'solvent')
  const model = file.replace('.ts', '')
  // Capitalize first letter for handler name (e.g., 'solvent' -> 'Solvent')
  const modelCap = model.charAt(0).toUpperCase() + model.slice(1)

  // Replace 'references' and 'Reference' placeholders
  const newContent = content
    .replace(/references/g, model)
    .replace(/Reference/g, modelCap)

  fs.writeFileSync(filePath, newContent)
  console.log(`Fixed ${file}`)
})
