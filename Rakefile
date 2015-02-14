require "bundler/gem_tasks"
require "openssl"
require "net/http"

TEMP_DIR = File.absolute_path("tmp")
DOWNLOAD_DIR = TEMP_DIR
BIN_DIR = File.absolute_path("bin")
TIKA_VERSION = "1.7"
PID_FILE = File.join(TEMP_DIR, "tika-server.pid")

tika_version = ENV["TIKA_VERSION"] || TIKA_VERSION
tika_path = File.join(BIN_DIR, "tika-server.jar")
tika_server = File.basename(tika_path)
tika_download_url = "http://archive.apache.org/dist/tika/tika-server-#{tika_version}.jar"
tika_checksum_url = "#{tika_download_url}.sha"
tika_checksum_type = :SHA1

namespace :tika do
  desc "Download Tika server"
  task :download => [:download_dir] do
    FileUtils.cd(DOWNLOAD_DIR) do
      puts "Downloading Tika ... "
      system "curl -L #{tika_download_url} -o #{tika_server}"
      checksum = Net::HTTP.get(URI(tika_checksum_url)).chomp
      puts "Verifiying checksum ... "
      digest = OpenSSL::Digest.const_get(tika_checksum_type).new
      digest << File.read(tika_server)
      if digest.to_s != checksum
        puts "Checksums do not match -- aborting!"
        FileUtils.remove_entry_secure(tika_server)
        abort
      end
      FileUtils.mv(tika_server, tika_path)
    end
  end

  desc "Start Tika server"
  task :start do
    if File.exists?(tika_path)
      puts "Starting Tika server ..."
      File.open(PID_FILE, "w") do |pid_file|
        pid = fork { exec "java -jar #{tika_path}" }
        Process.detach(pid)
        pid_file.write(pid)
      end
    else
      puts "Tika server not found - run `rake tika:download'."
    end
  end

  desc "Stop Tika server"
  task :stop do
    if File.exists?(PID_FILE)
      puts "Stopping Tika server ..."
      pid = File.read(PID_FILE).strip
      Process.kill("KILL", pid.to_i)
      File.unlink(PID_FILE)  
    else
      puts "Tika server is not running or was not started by `rake tika:start' task."
    end
  end
  
  desc "Check Tika server status"
  task :status do
    if File.exists?(PID_FILE)
      pid = File.read(PID_FILE).strip
      puts "Tika server is running (PID #{pid})"
    else
      puts "Tika server is not running or was not started by `rake tika:start' task."
    end
  end
end

task :download_dir do
  FileUtils.mkdir(DOWNLOAD_DIR) unless Dir.exists?(DOWNLOAD_DIR)
end
