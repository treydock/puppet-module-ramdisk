require 'spec_helper'

describe 'ramdisk', :type => :defined do
  let(:title) { 'ramdisk' }
  let(:facts) { {:kernelmajversion => '2.6'} }
  let(:default_params) do {
      :ensure   => 'present',
      :mount    => 'mounted',
      :path     => '/tmp/ramdisk',
      :fstype   => 'tmpfs',
      :options  => 'UNSET',
      :atboot   => true,
      :size     => '64M',
      :mode     => '1777',
      :owner    => 'root',
      :group    => 'root',
    }
  end
  let(:params) { default_params }

  it do
    should contain_file('/tmp/ramdisk').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '1777',
    })
  end

  it do
    should contain_mount('/tmp/ramdisk').with({
      'ensure'  => 'mounted',
      'device'  => 'tmpfs',
      'fstype'  => 'tmpfs',
      'options' => "size=64M,mode=1777,uid=root,gid=root",
      'atboot'  => true,
    })
  end

  context 'php example' do
    let(:params) do {
        :mount  => 'mounted',
        :path   => '/var/lib/php5',
        :size   => '128M',
        :mode   => '1733',
        :owner  => 'root',
        :group  => 'root',
        :atboot => true,
      }
    end

    it do
      should contain_file('/var/lib/php5').with({
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '1733',
      })
    end

    it do
      should contain_mount('/var/lib/php5').with({
        'ensure'  => 'mounted',
        'device'  => 'tmpfs',
        'fstype'  => 'tmpfs',
        'options' => "size=128M,mode=1733,uid=root,gid=root",
        'atboot'  => true,
      })
    end
  end
  
  context 'with options defined' do
    let :params do
      {
        :options => 'rw,uid=mysql,gid=mysql,size=1G,nr_inodes=10k,mode=0755'
      }
    end


    it do
      should contain_mount('/tmp/ramdisk').with({
        'options' => 'rw,uid=mysql,gid=mysql,size=1G,nr_inodes=10k,mode=0755',
      })
    end
  end
end