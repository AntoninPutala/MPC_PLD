# 2026-04-23T13:14:47.923090
import vitis

client = vitis.create_client()
client.set_workspace(path="Vitis_workspace")

platform = client.get_component(name="rp_top_platform")
domain = platform.get_domain(name="standalone_microblaze_I")

status = domain.set_config(option = "os", param = "standalone_stdout", value = "iomodule_0")

status = domain.set_config(option = "os", param = "standalone_stdin", value = "iomodule_0")

status = platform.build()

status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = domain.set_config(option = "os", param = "standalone_stdin", value = "mdm_0")

status = domain.set_config(option = "os", param = "standalone_stdout", value = "mdm_0")

status = platform.build()

status = domain.set_config(option = "os", param = "standalone_stdin", value = "iomodule_0")

status = domain.set_config(option = "os", param = "standalone_stdout", value = "iomodule_0")

status = platform.build()

status = platform.build()

status = domain.set_config(option = "os", param = "standalone_stdin", value = "mdm_0")

status = domain.set_config(option = "os", param = "standalone_stdout", value = "mdm_0")

status = platform.build()

vitis.dispose()

