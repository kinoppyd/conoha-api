require 'conoha_api/client/base'

module ConohaApi
  class Client
    module Compute
      SERVICE = 'compute'

      def flavors
        get "flavors"
      end

      def flavors_detail
        get "flavors/detail"
      end

      def flavor(id)
        get "flavors/#{id}"
      end

      def servers
        get "servers"
      end

      def servers_detail
        get "servers/detail"
      end

      def server(id)
        get "servers/#{id}"
      end

      def add_server(image_ref, flavor_ref, options = {})
        request_json = {
          server: {
            imageRef: image_ref,
            flavorRef: flavor_ref
          }
        }

        request_json[:server][:adminPass] = options[:admin_pass] if options[:admin_pass]
        request_json[:server][:keyName] = options[:key_name] if options[:key_name]
        post "servers", request_json, options
      end

      def delete_server(id)
        delete "servers/#{id}"
      end

      def start_server(id)
        action(id, :"os-start" => nil)
      end

      def reboot_server(id, type = 'SOFT')
        raise ArgumentError.new("#{type} is not valid") unless ['SOFT', 'HARD'].include?(type.upcase)
        action(id, reboot: { type: type.upcase })
      end

      def force_stop_server(id, force = true)
        action(id, :"os-stop" => { force_shutdown: force })
      end

      def stop_server(id)
        action(id, :"os-stop" => nil)
      end

      def rebuild_server(id, image_ref, options = {})
        request_json = {
          rebuild: {
            imageRef: image_ref
          }
        }
        request_json[:rebuild][:adminPass] = options[:admin_pass] if options[:admin_pass]
        request_json[:rebuild][:keyName] = options[:key_name] if options[:key_name]
        action(id, request_json)
      end

      def resize(id, flavor_ref)
        action(id, resize: { flavorRef: flavor_ref })
      end

      def confirm_resize(id)
        action(id, confirmResize: nil)
      end

      def revert_resize(id)
        action(id, revertResize: nil)
      end

      def vnc(id)
        action(id, :"os-getVNCConsole" => { type: :novnc })
      end

      def create_image(id, name)
        action(id, createImage: { name: name })
      end

      def change_strage_controller(id, hardware_disk_bus)
        raise ArgumentError.new("#{hardware_disk_bus} is not valid") unless ['virtio', 'scsi', 'ide'].include?(hardware_disk_bus)
        action(id, hwDiskBus: hardware_disk_bus)
      end

      def change_network_adapter(id, hardware_virtualinterface_model)
        raise ArgumentError.new("#{hardware_virtualinterface_model} is not valid") unless ['e1000', 'virtio', 'rtl8139'].include?(hardware_virtualinterface_model)
        action(id, hwVifModel: hardware_virtualinterface_model)
      end

      def change_video_device(id, hardware_video_model)
        raise ArgumentError.new("#{hardware_video_model} is not valid") unless ['qxl', 'vga', 'cirrus'].include?(hardware_video_model)
        action(id, hwVideoModel: hardware_video_model)
      end

      def change_console_keymap(id, vnc_keymap)
        raise ArgumentError.new("#{vnc_keymap} is not valid") unless ['us-en', 'jp'].include?(vnc_keymap)
        action(id, vncKeymap: vnc_keymap)
      end

      def get_web_console(id, type = 'nova')
        raise ArgumentError.new("#{type} is not valid") unless ['nova', 'http'].include?(type)
        request_json = {}
        type == 'nova' ? request_json[:"os-getSerialConsole"] = {type: :serial} : request_json[:"os-getWebConsole"] = {type: :serial}
        action(id, request_json)
      end

      def mount_iso_image(id, file_path)
        action(id, mountImage: file_path)
      end

      def unmount_iso_image(id)
        action(id, unmountImage: nil)
      end

      def action(id, query)
        post "servers/#{id}/action", query
      end
      private :action

      def keypairs
        get "os-keypairs"
      end

      def keypair(name)
        get "os-keypairs/#{name}"
      end

      def add_keypair(name, public_key = nil)
        request_json = {
          keypair: {
            name: name
          }
        }
        request_json[:keypair][:public_key] = public_key if public_key
        post "os-keypairs", request_json
      end

      def delete_keypair(name)
        delete "os-keypairs/#{name}"
      end

      def images
        get "images"
      end

      def images_detail(options = {})
        get "images/detail", options
      end

      def image(id)
        get "images/#{id}"
      end
    end
  end
end
