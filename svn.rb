require 'net/http'
require 'uri'

module SVN

  class << self
    attr_accessor :username, :password
  end
  
  # Returns a string to be passed into commands containing authentication options
  # Requires setting of username and password via attr_accessor methods
  def self.authentication_details
    "--username #{@username} --password #{@password}"
  end

  # Returns an array representing the current status of any new or modified files
  def self.status
    SVN.execute("status").split(/\n/).map do |file|
      file =~ /(\?|\!|\~|\*|\+|A|C|D|I|M|S|X)\s*([\w\W]*)/
      [$1, $2]
    end
  end
  
  # Adds the given path to the working copy
  def self.add(path)
    SVN.execute("add #{path}")
  end
  
  # Adds all new or modified files to the working copy
  def self.add_all
    SVN.status.each { |file| add = SVN.add(file[1]) if file[0] == '?' }
  end
  
  # Add all new or modified files to the working copy and commits changes
  # An optional commit message can be passed if required
  def self.add_and_commit_all(message=nil)
    SVN.add_all
    SVN.commit message
  end
  
  # Commits all changes, and returns the new revision number
  # An optional commit message can be passed if required
  def self.commit(message=nil)
    if message.nil?
      action = SVN.execute("commit")
    else
      action = SVN.execute("commit -m '#{message}'")
    end
    if action.split(/\n/).last =~ /Committed revision (\d+)\./
      return $1
    else
      return nil
    end
  end
  
  # Returns a diff of two commits based on their respective revision numbers
  # (first and second arguments) and a repository path (third argument)
  def self.diff(revision_1,revision_2,file=nil)
    if file.nil?
      SVN.execute("diff -r #{revision_1}:#{revision_2}")
    else
      SVN.execute("diff -r #{revision_1}:#{revision_2} #{file}")
    end
  end

  # Retrieve a file based on it's path and commit revision number
  def self.get(file,revision)
    SVN.execute("cat -r #{revision} #{file}")
  end

  # Rename a file based on the given current and new filenames
  def self.rename(old_filename, new_filename)
    SVN.execute("rename #{old_filename} #{new_filename}")
  end

  # Delete a file based on a given path
  def self.delete(file)
    SVN.execute("delete #{file}")
  end

  private

  def self.execute(command)
    %x{svn #{command} #{SVN.authentication_details}}
  end

end