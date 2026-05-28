# 2026-04-30T11:45:23.398050400
import vitis

client = vitis.create_client()
client.set_workspace(path="Zynq_work")

platform = client.create_platform_component(name = "rp_zynq",hw_design = "$COMPONENT_LOCATION/../../Zynq_demo/rp_zync.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",compiler = "gcc")

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../rp_zynq/export/rp_zynq/rp_zynq.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

platform = client.get_component(name="rp_zynq")
status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

comp = client.create_app_component(name="hello_world_blinky",platform = "$COMPONENT_LOCATION/../rp_zynq/export/rp_zynq/rp_zynq.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

status = platform.build()

comp = client.get_component(name="hello_world_blinky")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

vitis.dispose()

