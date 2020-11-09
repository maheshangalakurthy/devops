require "docker"
require "docker-api"
require "serverspec"

FILEBEAT_PORT = 8080
describe 'Dockerfile' do
    before(:all) do
        @image = Docker::Image::build_from_dir('.')
        @image.tag(repo: 'angalakurthymahesh/ubuntu', tag: 'latest')
        @container = @image.run()
        set :os, family: :redhat
        set :backend, :docker
        set :docker_image, @image.id
        set :Docker_container, @container.id
    end

    describe command('whoami') do
        its(:stdout) { should match('filebeat') }
    end

    describe file('/etc/os-release') do
        it { should be_file }
    end

    describe user('filebeat') do
        it { should exist }
        it { should belong_to_group 'filebeat' }
        it { should belong_to_primary_group 'filebeat' }
        it { should have_uid 1000 }
        it { should have_home_directory '/home/filebeat' }
        it { should have_login_shell '/bin/bash' }
    end
    
    describe group('filebeat') do
        it { should exist }
        it { should have_gid 1000 }
    end

    describe file('/usr/share/filebeat') do
        it { should be_directory }
        it { should exist }
        it { should be_owned_by 'filebeat' }
        it { should be_grouped_into 'filebeat' }
    end

    describe file('/usr/share/filebeat/bin/filebeat') do
        it { should be_file }
        it { should be_owned_by 'filebeat' }
        it { should be_grouped_into 'filebeat' }
    end

    describe command('rpm -qa | grep filebeat') do
        its(:stdout) { should match('filebeat-5.2.0-1.x86_64') }
    end
    
end
