class StoredProcedureService

  def self.instance
    @instance ||= StoredProcedureService.new
  end

  def execute(name, *args)
    results = []
    begin
      connection.execute("CALL #{name}(#{args.join(',')})").each(as: :hash, symbolize_keys: true) do |row|
        
        results << OpenStruct.new(row)
      end
    ensure
      connection.close
    end
    results
  end

  def connection
    ActiveRecord::Base.connection
  end
end