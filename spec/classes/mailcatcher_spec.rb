require 'spec_helper'

describe 'mailcatcher', :type => :class do
  context "As a Web Operations Engineer" do
    context 'When I install the mailcatcher base class on Ubuntu' do
      let :facts do {
          :osfamily        => 'Debian',
          :operatingsystem => 'Ubuntu'
      }
      end

      describe 'by default it' do
        it { should contain_package('ruby-dev') }
        it { should contain_package('sqlite3') }
        it { should contain_package('libsqlite3-dev') }
        it { should contain_package('rubygems') }
        it { should contain_package('mailcatcher').with({ 'provider' => 'gem'}) }
        it { should contain_user('mailcatcher')}
        it { should contain_file('/etc/init/mailcatcher.conf').with_content(/--http-ip\s0.0.0.0/)}
        it { should contain_file('/etc/init/mailcatcher.conf').with_content(/--http-port\s1080/)}
        it { should contain_file('/etc/init/mailcatcher.conf').with_content(/--smtp-ip 0.0.0.0/)}
        it { should contain_file('/etc/init/mailcatcher.conf').with_content(/--smtp-port\s1025/)}
        it { should contain_file('/etc/init/mailcatcher.conf').with({ :notify => 'Class[Mailcatcher::Service]'})}
        it { should contain_file('/var/log/mailcatcher').with({
            :ensure  => 'directory',
            :owner   => 'mailcatcher',
            :group   => 'mailcatcher',
            :mode    => '0755',
            :require => 'User[mailcatcher]'
        })}
        it { should contain_service('mailcatcher').with({
            :ensure     => 'running',
            :provider   => 'upstart',
            :hasstatus  => true,
            :hasrestart => true,
            :require    => 'Class[Mailcatcher::Config]',
        })}

      end
    end
  end
end
