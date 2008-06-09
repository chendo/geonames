###
# Apollo rake tasks
# @author Chris Scott
#
desc 'Geonames import task'
namespace :geonames do

    task :import => :environment do
        puts "*************************************************************************************"
        puts " Importing geonames "
        puts "*************************************************************************************"
                       
        Resistor::Geonames.import                                                                
    end
    
    desc "Export geonames to /db"
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

