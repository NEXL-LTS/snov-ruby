module Snov
  class FakeClient
    def self.folder=(val)
      @folder = val
      FileUtils.mkdir_p(@folder)
      ["post_v1_get-profile-by-email", "get_v2_domain-emails-with-info",
       "post_v1_get-prospects-by-email", "post_v1_prospect-list", "get_v1_get-user-lists"].each do |sub_folder|
        FileUtils.cp_r "#{default_folder}/#{sub_folder}", @folder
      end
    end

    def self.folder
      @folder || default_folder
    end

    def self.reset_folder
      @folder = nil
    end

    def self.default_folder
      "#{__dir__}/fake_client"
    end

    def get(path, payload_hash = {})
      data = File.read(filename("get", path, payload_hash))
      MultiJson.load(data)
    rescue Errno::ENOENT
      data = File.read(filename("get", path, 'not_found' => 'true'))
      MultiJson.load(data)
    end

    def post(path, payload_hash = {})
      data = File.read(filename("post", path, payload_hash))
      MultiJson.load(data)
    rescue Errno::ENOENT => e
      file = filename("post", path, 'not_found' => 'true')
      if File.exist?(file)
        MultiJson.load(File.read(file))
      else
        raise Snov::Client::BadRequest, e.message
      end
    end

    private

    def filename(method, path, payload_hash)
      add = payload_hash.to_a.map { |v| v.join("=") }.join("&").tr(".", "_")
      add = "default" if add == ""
      "#{self.class.folder}/#{method}#{path.tr("/", "_")}/#{add.gsub('/', '-')}.json"
    end
  end
end
