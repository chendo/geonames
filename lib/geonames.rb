###
# @module Resistor::Geonames
module Resistor
    module Geonames

        COUNTRIES = "#{File.dirname(__FILE__)}/../db/countryInfo.txt"
        REGIONS = "#{File.dirname(__FILE__)}/../db/admin1Codes.txt"
        CITIES_1000 = "#{File.dirname(__FILE__)}/../db/cities1000.txt"
        CITIES_5000 = "#{File.dirname(__FILE__)}/../db/cities5000.txt"
        CITIES_15000 = "#{File.dirname(__FILE__)}/../db/cities15000.txt"

        @@countries = {}
        @@regions = {}

        ##
        # import
        #
        def self.import
            puts "Resistor::Geonames.import"
            if (FileTest.exist?(COUNTRIES))
                self.import_countries
            end

            if (FileTest.exist?(REGIONS))
                self.import_regions
            end

            if (FileTest.exist?(CITIES_1000))
                self.import_cities1000
            end

            if (FileTest.exist?(CITIES_5000))
                self.import_cities5000
            end

            if (FileTest.exist?(CITIES_15000))
                self.import_cities15000
            end

        end

        ##
        # import_countries
        # [0] iso alpha2
        # [1] iso alpha3
        # [2] iso numeric
        # [3] fips code
        # [4] name
        # [5] capital
        # [6] areaInSqKm
        # [7] population
        # [8] continent
        # [9] languages
        # [10] currency
        # [11] geonameId
        #
        def self.import_countries

            f = File.open(COUNTRIES)

            # first get rid of comments and headers
            line = f.gets
            while (line.match(/^#/) or line.match(/^iso/))
                line = f.gets
            end

            # since line already exists.. we can process it now...
            while (line)
                line = line.split(/\t/)
                puts "Attempting to add country: #{line[4]}"
                @@countries[line[0]] = Country.create(:iso => line[0], :name => line[4], :geoname_id => line[11])

                # if the country already exists, add the existing record to the country hash
                if @@countries[line[0]].id.nil?
                    c = Country.find_by_geoname_id(line[11])
                    puts "Existing record #{c.id}, #{c.iso}, #{c.name}, #{c.geoname_id}"
                    @@countries[line[0]] = c.attributes
                end
                line = f.gets
            end
            puts "There are now #{@@countries.size} Countries in the system."
        end

        ##
        # import_regions
        # [0] AD.00     <-- info = row[0].split('.')
        # [1] name
        #
        def self.import_regions
            f = File.open(REGIONS)
            while (row = f.gets)
                row = row.split(/\t/)
                (country, region_index) = row[0].split('.')
                if (!@@countries[country].nil?)
                    if region_index != '00'
                        #puts "Checking if record exists #{row[1]}"
                        r = Region.find(:first, :conditions => {:name => row[1], :iso => region_index, :country_id => @@countries[country]["id"]})
                        puts "looking for r to be what #{r.class.to_s}"
                        # if r is not an ActiveRecord it is probably a good idea to create one
                        if r.nil?
                            puts "Attempting to add region: #{row[1]}"
                            r = Region.create(:iso => region_index, :country_id => @@countries[country]["id"], :name => row[1])
                        else
                            #puts("Found an existing match, so we skipped creating a new one")
                        end

                        ###
                        # everytime a new region is created, and attached to a country, we should add this new region
                        # to the @@countries so that we can quickly identify the PK of the region for cities since a city
                        # will have the country ISO code and the Region ISO code
                        puts "no matter what, r is an object of #{r.class.to_s}"
                        unless r.nil?
                           @@countries[country][region_index] = r.id
                        end
                    end
                else
                    puts "Country not found #{country} with region index #{region_index}"
                end
            end
        end


        ##
        # import_cities Schema (same for 1000, 5000 and 15000+ cities)
        # ---------------------------------------------------------------------------------------
        # [0] geonameid         : integer id of record in geonames database
        # [1] name              : name of geographical point (utf8) varchar(200)
        # [2] asciiname         : name of geographical point in plain ascii characters, varchar(200)
        # [3] alternatenames    : alternatenames, comma separated varchar(4000)
        # [4] latitude          : latitude in decimal degrees (wgs84)
        # [5] longitude         : longitude in decimal degrees (wgs84)
        # [6] feature class     : see http://www.geonames.org/export/codes.html, char(1)
        # [7] feature code      : see http://www.geonames.org/export/codes.html, varchar(10)
        # [8] country code      : ISO-3166 2-letter country code, 2 characters
        # [9] cc2               : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
        # [10] admin1 code       : fipscode (subject to change to iso code), isocode for the us and ch, see file admin1Codes.txt for display names of this code; varchar(20)
        # [11] admin2 code       : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80)
        # [12] admin3 code       : code for third level administrative division, varchar(20)
        # [13] admin4 code       : code for fourth level administrative division, varchar(20)
        # [14] population        : integer
        # [15] elevation         : in meters, integer
        # [16] gtopo30           : average elevation of 30'x30' (ca 900mx900m) area in meters, integer
        # [17] timezone          : the timezone id (see file timeZone.txt)
        # [18] modification date : date of last modification in yyyy-MM-dd format
        #
        # @param {File} file_ptr
        def self.import_cities(file_ptr)
            counter = 0
            while (row = file_ptr.gets)
                # what do we want to inert into the city table
                row = row.split(/\t/)

                # first, find me a region to connect this city to, using the country and fips code
                region_id = @@countries[row[8]][row[10]]
                #puts "city will belong to region #{region_id}"

                # Check to see if the city already exists or not based on the criteria we'll use to enter it into the system
                c = City.find(:first, :conditions => {:geoname_id => row[0], :name => row[1], :region_id => region_id})
                #puts "city object #{c.class.to_s}"

                if c.nil?
                    #puts "City was not found in the database, so we create a new one"
                    #puts "name #{row[1]} geoname_id #{row[0]}, region_id #{row[10]} latitude #{row[4]}, longtitude #{row[5]}"
                    unless region_id.nil?
                        puts "Adding City #{counter += 1} #{row[1]}"
                        City.create(:geoname_id => row[0], :region_id => region_id, :name => row[1], :name_ascii => row[2], :lat => row[4], :lng => row[5])
                    end
                end
            end
            puts "There are now #{City.count()} cities in the city table"
        end

        def self.import_cities1000
            self.import_cities(File.open(CITIES_1000))
        end

        def self.import_cities5000
            self.import_cities(File.open(CITIES_5000))
        end

        def self.import_cities15000
            self.import_cities(File.open(CITIES_15000))
        end
    end
end



