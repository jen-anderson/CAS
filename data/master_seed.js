import fs from 'fs';
import path from 'path';

/**
 * @param {import('knex').Knex} knex
 */
export async function seed(knex) {
  // adjust path to where SQL files are stored
  const seedFolder = path.resolve('./data');

  const files = fs.readdirSync(seedFolder)
    .filter(f => f.endsWith('.sql'))
    .sort(); // ensures 1_… comes before 2_…

  await knex.raw(`
    TRUNCATE TABLE reference CASCADE;
    TRUNCATE TABLE formula CASCADE;
    TRUNCATE TABLE property_type CASCADE;
    TRUNCATE TABLE solvent CASCADE;
    TRUNCATE TABLE solvent_formula CASCADE;
    TRUNCATE TABLE observation CASCADE;
    TRUNCATE TABLE alias CASCADE;
    TRUNCATE TABLE hazard_code CASCADE;
    TRUNCATE TABLE p_code CASCADE;
    TRUNCATE TABLE alias_reference CASCADE;
    TRUNCATE TABLE formula_hazard CASCADE;
    TRUNCATE TABLE hazard_pcode CASCADE;
    TRUNCATE TABLE pcode_group_map CASCADE;
    TRUNCATE TABLE solvent_hazard CASCADE;
    TRUNCATE TABLE pcode_group CASCADE;
    TRUNCATE TABLE hazard_classification CASCADE;
    TRUNCATE TABLE solvent_reference CASCADE;
  `);  

  for (const file of files) {
    const rawSql = fs.readFileSync(path.join(seedFolder, file), 'utf8');
    const sql = rawSql.trim();

    if (sql) {
      console.log(`Running seed file: ${file}`);
      await knex.raw(sql);
    }
  }

  console.log('All seeds executed successfully!');
}