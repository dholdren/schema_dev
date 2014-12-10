require 'simplecov'
SimpleCov.start

require 'tmpdir'

require 'schema_dev/config'

def get_config(data)
  SchemaDev::Config._reset
  Dir.mktmpdir do |dir|
    Dir.chdir(dir) do
      Pathname.new(SchemaDev::CONFIG_FILE).open("w") {|f| f.write data.to_yaml }
      SchemaDev::Config.load
    end
  end
end
