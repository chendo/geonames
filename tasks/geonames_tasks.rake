###
# Apollo rake tasks
# @author Chris Scott
#
namespace :geonames do 
    
    
    task :import => :environment do
        puts "*************************************************************************************"
        puts " Importing geonames "
        puts "*************************************************************************************"
        
        Resistor::Geonames.import
                                                                
    end
end
    
