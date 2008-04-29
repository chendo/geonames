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
                        puts "Attempting to add region: #{row[1]}"
                        r = Region.create(:iso => region_index, :country_id => @@countries[country]["id"], :name => row[1])
                        if !r.id
                            puts "Region #{r.name} already exists"
                        else
                            puts "Newly added Region #{Region.name}"
                        end
                    end
                else
                    puts "Country not found #{country} with region index #{region_index}"
                end
            end
        end

        ##
        # import_cities1000
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
        def self.import_cities1000

        end

        ##
        # import_cities5000
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
        def self.import_cities5000

        end

        ##
        # import_cities15000
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
        def self.import_cities15000

        end
    end
end
