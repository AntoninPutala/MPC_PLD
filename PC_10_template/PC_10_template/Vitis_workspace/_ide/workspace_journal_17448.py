# 2026-04-23T13:00:55.529320300
import vitis

client = vitis.create_client()
client.set_workspace(path="Vitis_workspace")

platform = client.create_platform_component(name = "rp_top_platform",hw_design = "$COMPONENT_LOCATION/../../SOURCES/HW_platform/rp_top.xsa",os = "standalone",cpu = "microblaze_I",domain_name = "standalone_microblaze_I",compiler = "gcc")

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../rp_top_platform/export/rp_top_platform/rp_top_platform.xpfm",domain = "standalone_microblaze_I",template = "hello_world")

platform = client.get_component(name="rp_top_platform")
status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

