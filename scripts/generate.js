import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const models = [
  'property_type',
  'solvent',
  'alias',
  'observation',
  'formula',
  'solvent_formula',
  'hazard_code',
  'p_code',
  'hazard_classification',
  'pcode_group',
  'alias_reference',
  'formula_hazard',
  'hazard_pcode',
  'pcode_group_map',
  'solvent_hazard',
  'solvent_reference',
]

// 1. Read the template
const template = fs.readFileSync(
  path.join(__dirname, 'lib/_handlers/references.ts'),
  'utf8',
)

models.forEach(model => {
  // Helper: Convert 'solvent_reference' to 'Solvent_reference'
  const modelCap = model.charAt(0).toUpperCase() + model.slice(1)

  const newContent = template
    .replace(/references/g, model)
    .replace(/Reference/g, modelCap)

  fs.writeFileSync(
    path.join(__dirname, 'lib/_handlers', `${model}.ts`),
    newContent,
  )
  console.log(`Generated ${model}.ts`)
})

// 3. Generate route mapping (now using the handler name convention: model + 'Handler')
const routeMapping = models
  .map(model => {
    // Convert 'solvent_reference' to 'solvent_referenceHandler'
    return `  "/${model}": ${model}Handler`
  })
  .join(',\n')

const routerFile = `import { ${models.map(m => m + 'Handler').join(', ')} } from './_handlers';

export const routes = {
${routeMapping}
};
`

fs.writeFileSync('./routes.ts', routerFile)
console.log('Generated routes.ts')
