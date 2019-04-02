require('pg')

class Bounty

  attr_accessor :name, :species, :bounty_value, :danger_level
  attr_reader :id

  def initialize (options)
    @name = options['name']
    @species = options['species']
    @bounty_value = options['bounty_value']
    @danger_level = options['danger_level']
    @id = options['id'].to_i if options['id']
  end

  def save()
    # connect to db
    db = PG.connect( {dbname: 'bounties',
                      host: 'localhost'})
    #write sql statement string
    sql = "INSERT INTO bounties
            (
              name,
              species,
              bounty_value,
              danger_level
              )
              VALUES ($1, $2, $3, $4)
              RETURNING id
              "
    #create values array for prepared statement
    values = [@name, @species, @bounty_value, @danger_level]
    # use pg to run prepared statement
    db.prepare("save", sql)
    # run prepared statement with pg
    @id = db.exec_prepared("save", values)[0]["id"].to_i
    #close db
    db.close()
  end

  # create a function to read the db (not in the homework but good practice)

  def Bounty.all()
    #first connect to db
    db = PG.connect( {dbname: 'bounties',
                      host: 'localhost'})
    #write sql statement
    sql "SELECT * FROM bounties"
    #prepare statement
    db.prepare("all", sql)
    #run prepared statement
    db.exec_prepared("all")
    #close connection
    db.close()
  end

  # Create update function
    def update()
      #connect to db
      db = PG.connect( {dbname: 'bounties',
                        host: 'localhost'})
      #write sql statement
      sql = "UPDATE bounties
      SET (
        name,
        species,
        bounty_value,
        danger_level
        ) =
        (
          $1, $2, $3, $4
          )
          WHERE id = $5
          "
      #setup values array
      values = [@name, @species, @bounty_value, @danger_level, @id]
      #prepare statement
      db.prepare("update", sql)
      #run query
      db.exec_prepared("update", values)
      #close db connection
      db.close()
    end


  # Create delete all function
  def Bounty.delete_all()
    #connect to db
    db = PG.connect( {dbname: 'bounties',
                      host: 'localhost'})
    #write sql statement
    sql = "DELETE FROM bounties"
    #prepare statement
    db.prepare("delete_all", sql)
    #exec statement
    db.exec_prepared("delete_all")
    #close connection to db
    db.close()
  end

  # create delete instance function
  def delete()
    #connect to db
    db = PG.connect( {dbname: 'bounties',
                      host: 'localhost'})
    #write sql statement
    sql = "DELETE FROM bounties WHERE id = $1"
    #create values array
    values = [@id]
    #prepare statement
    db.prepare("delete", sql)
    #exec prepared statement
    db.exec_prepared("delete", values)
    #close db connection
    db.close()

  end

  #####EXTENSIONS#####

  def Bounty.find_by_name(name)
    #connect to db
    db = PG.connect( {dbname: 'bounties',
                      host: 'localhost'})
    #write sql statement
    sql = "SELECT * FROM bounties
    WHERE name = $1"
    #create values array
    values = [name]
    #prepare statement
    db.prepare("find_by_name", sql)
    #exec prepared statement
    found = db.exec_prepared("find_by_name", values)

    #return the row
    instances = found.map {|bounty| Bounty.new(bounty)}
    if instances == []
      return nil
    else
      return instances
    end
    #close db connection
    db.close()
  end

  #Create function to find by id

  def Bounty.find_by_id(id)
    #connect to db
    db = PG.connect( {dbname: 'bounties',
                      host: 'localhost'})
    #write sql statement string
    sql = "SELECT * FROM bounties
    WHERE id = $1"
    #create values array
    values = [id]
    #write prepare statement
    db.prepare("find_by_id", sql)
    #exec prepare statement
    found = db.exec_prepared("find_by_id", values)[0]
    #return the row
    return Bounty.new(found)
    #close db connection
    db.close()
  end


end
