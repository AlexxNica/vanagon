require 'vanagon/project/dsl'
require 'vanagon/driver'
require 'vanagon/common'

describe 'Vanagon::Project::DSL' do
  let (:project_block) {
"project 'test-fixture' do |proj|
end" }
  let (:configdir) { '/a/b/c' }

  describe '#version_from_git' do
    it 'sets the version based on the git describe' do
      Vanagon::Driver.new('abcd', 'abcd', configdir)
      proj = Vanagon::Project::DSL.new('test-fixture', {})
      proj.instance_eval(project_block)
      expect(Vanagon::Utilities).to receive(:git_version).with(File.expand_path('..', configdir)).and_return('1.2.3-1234')
      proj.version_from_git
      expect(proj._project.version).to eq('1.2.3.1234')
    end
  end

  describe '#directory' do
    it 'adds a directory to the list of directories' do
      proj = Vanagon::Project::DSL.new('test-fixture', {})
      proj.instance_eval(project_block)
      proj.directory('/a/b/c/d', mode: '0755')
      expect(proj._project.directories).to be_include(Vanagon::Common::Pathname.new('/a/b/c/d', '0755'))
    end
  end

  describe '#user' do
    it 'sets a user for the project' do
      proj = Vanagon::Project::DSL.new('test-fixture', {})
      proj.instance_eval(project_block)
      proj.user('test-user')
      expect(proj._project.user).to eq(Vanagon::Common::User.new('test-user'))
    end
  end
end
