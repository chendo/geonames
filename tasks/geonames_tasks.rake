###
# Geonames plugin is great for building up and tearing down some commonly needed region tables
# author Chris Scott
# author D. Lazar

namespace :geonames do

    desc 'dump - use pgsql to dump data to files'    
    task :dump => :environment do
        puts "*************************************************************************************"
        puts " Dumping geonames tables to /db with pg_dump"
        puts "*************************************************************************************"

        config = ActiveRecord::Base.configurations[RAILS_ENV]

        ["country", "country_region", "country_region_city", "country_region_city_airport"].each do |name|
            cmd = "/usr/bin/pg_dump -U postgres -t #{name} -a #{config['database']} --format=c > db/#{name}.sql"
            # show cmd user before execing
            puts ">#{cmd}"
            puts `#{cmd}`
        end
    end

    desc 'restore - use pgsql to restore data from files'
    task :restore => :environment do
        puts "*************************************************************************************"
        puts " Restoring geonames tables to from backup in /db "
        puts "*************************************************************************************"

        config = ActiveRecord::Base.configurations[RAILS_ENV]

        ["country", "country_region", "country_region_city", "country_region_city_airport"].each do |name|
            cmd = "/usr/bin/pg_restore -U postgres -t #{name} -a -d #{config['database']} --format=c < db/#{name}.sql"
            # show cmd user before execing
            puts ">#{cmd}"
            puts `#{cmd}`
        end

    end

    desc 'import - read text files for country, region and city tables to build database'
    task :import => :environment do
        puts "*************************************************************************************"
        puts " Importing geonames "
        puts "*************************************************************************************"

        Resistor::Geonames.import
    end

    desc "export data to yaml files"
    task :export => :environment do
        puts "*************************************************************************************"
        puts " Exporting geonames to db/geonames.yml "
        puts "*************************************************************************************"

        output = {
            :countries => [],
            :regions => [],
            :cities => []
        }
        cities = City.find(:all, :include => [:region])
        regions = Region.find(:all, :include => [:country])
        countries = Country.find(:all)

        countries.each do |c|
            output[:countries] << {
                :iso => c.iso,
                :name => c.name
            }
        end
        regions.each do |r|
            output[:regions] << {
                :country => r.country.iso,
                :iso => r.iso,
                :name => r.name
            }
        end
        cities.each do |c|
            output[:cities] << {
                :name => c.name,
                :country => c.region.country.iso,
                :region => c.region.iso,
                :lat => c.lat,
                :lng => c.lng
            }
        end

        f = File.new('db/geonames.yml', File::CREAT|File::RDWR|File::TRUNC, 0644)
        f << output.to_yaml
        f.close

        if !Airports.nil?
            output = {:airports => []}
            airports = Airport.find(:all)
            airports.each do |a|
                output[:airports] << a.attributes
            end
            f = File.new('db/airports.yml', File::CREAT|File::RDWR|File::TRUNC, 0644)
            f << output.to_yaml
            f.close
        end

        Resistor::Geonames.import
    end
end

