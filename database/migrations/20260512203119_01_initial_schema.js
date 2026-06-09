import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const files = [
  '01_core.sql',
  '02_formula.sql',
  '03_hazard.sql',
  '04_relationships.sql',
  '05_functions.sql',
  '06_triggers.sql',
  '07_comments.sql'
];

/**
 * @param {import('knex').Knex} knex
 */
export async function up(knex) {
  for (const file of files) {
    const sql = fs.readFileSync(path.join(__dirname, '../schema', file), 'utf8');
    await knex.raw(sql);
  }
}

/**
 * @param {import('knex').Knex} knex
 */
export async function down(knex) {
  // Using a single raw query with CASCADE cleanly wipes the slate.
  await knex.raw(`
    DROP TRIGGER IF EXISTS your_trigger_name ON your_table_name CASCADE;
    DROP FUNCTION IF EXISTS your_function_name CASCADE;
    
    DROP TABLE IF EXISTS relationships CASCADE;
    DROP TABLE IF EXISTS hazard CASCADE;
    DROP TABLE IF EXISTS formula CASCADE;
    DROP TABLE IF EXISTS core CASCADE;
  `);
}
