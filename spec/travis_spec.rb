require 'schema_dev/travis'

describe SchemaDev::Travis do

  it "creates travis file" do
    config = get_config(ruby: %W[1.9.3 2.1.5],
                        rails: %W[4.0 4.1],
                        db: %W[sqlite3 postgresql],
                        exclude: { ruby: "1.9.3", db: "postgresql" },
                        notify: 'me@example.com')
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        SchemaDev::Travis.update(config)
        expect(Pathname.new(".travis.yml").read).to eq <<ENDTRAVIS
# This file was auto-generated by the schema_dev tool, based on the data in
#                 ./schema_dev.yml
# Please do not edit this file; any changes will be overwritten next time
# schema_dev gets run.
---
rvm:
- 1.9.3
- 2.1.5
gemfile:
- gemfiles/rails-4.0/Gemfile.postgresql
- gemfiles/rails-4.0/Gemfile.sqlite3
- gemfiles/rails-4.1/Gemfile.postgresql
- gemfiles/rails-4.1/Gemfile.sqlite3
before_script: bundle exec rake create_databases
after_script: bundle exec rake drop_databases
env: POSTGRESQL_DB_USER=postgres
notifications:
  email:
  - me@example.com
matrix:
  exclude:
  - rvm: 1.9.3
    gemfile: gemfiles/rails-4.0/Gemfile.postgresql
    env: POSTGRESQL_DB_USER=postgres
  - rvm: 1.9.3
    gemfile: gemfiles/rails-4.1/Gemfile.postgresql
    env: POSTGRESQL_DB_USER=postgres
ENDTRAVIS
      end
    end
  end
end