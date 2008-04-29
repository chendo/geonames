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
end

