module ExpireCache
  
  protected
    # Expire directory with all sub-directories and files
    def expire_dir(path)
      FileUtils.rm_rf "#{RAILS_ROOT}/public/#{path}"
    end
    
    # Expire all dirs location in {path}
    # {path} - regex
    def expire_dirs(path)
      FileUtils.rm_rf Dir.glob("#{RAILS_ROOT}/public/#{path}")
    end
    
    # Expire file location in path
    def expire_file(path)
      if File.file? "#{RAILS_ROOT}/public/#{path}"
        FileUtils.rm "#{RAILS_ROOT}/public/#{path}"
      end
    end
    
    # Expire all files in directory {path}
    def expire_files(path)
      FileUtils.rm Dir.glob("#{RAILS_ROOT}/public/#{path}")
    end

end
