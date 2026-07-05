const common = {
  pool: {
      min: 2,
      max: 10
    },
  migrations: {
    tableName: 'knex_migrations',
    directory: './migrations'
  },
  seeds: {
    directory: './data'
  }
};

export default {
  development: {
    client: 'pg',
    connection: {
      host: '127.0.0.1',   
      user: 'cas_user',
      password: 'SolventSolving',
      database: 'cas_project'
    },
    ...common
  },
  

  staging: {
    client: 'pg',
    connection: {
      database: 'cas_project',
      user:     'cas_user',
      password: 'SolventSolving'
    },
    ...common
  },

  production: {
    client: 'pg',
    connection: {
      host: '127.0.0.1',
      user: 'prod_user',
      password: 'prod_password',
      database: 'prod_db'
    },
    ...common
  }

};
