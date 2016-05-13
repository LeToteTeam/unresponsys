class Unresponsys
  class Folders
    def initialize(client)
      @client = client
    end

    def find(folder_name)
      Folder.new(@client, folder_name)
    end
  end
end
