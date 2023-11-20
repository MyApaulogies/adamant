from models.packets import packets, packet
from models.exceptions import ModelException
from util import model_loader
from util import redo


# This model is a specialized packet suite for the CPU monitor packet. This
# class inherits from the normal packets model but adds some extra functionality
# needed to the CPU monitor packet. In particular, the CPU monitor packet's
# type is derived from data within the assembly that the packet is a part of. The
# type itself gets filled in in the "load_assembly" method.
class cpu_monitor_packets(packets):
    # This is just a "decorated" packet object, so make sure everyone treats it like that.
    def submodel_name(self):
        return "packets"

    def set_assembly(self, assembly):
        # Set assembly:
        self.assembly = assembly

        # Stuff the CPU Usage packet type with the autogenerated type based on the
        # assembly. Even though this packed record is not used by the FSW, this will
        # allow the CPU Usage packet format to be available for decoding by ground tools
        # using the standard method of packed records.
        for key, pkt in self.entities.items():
            if pkt.name == "Cpu_Usage_Packet":
                # First, lets get the path to the model file that will be the type for this packet:
                model_name = self.assembly.name + "_cpu_monitor_packet_type"
                model_path = model_loader.get_model_file_path(
                    model_name, model_types=["record"]
                )
                if not model_path:
                    raise ModelException(
                        "Could not find CPU Monitor packet type model file: '"
                        + model_name
                        + "'."
                    )

                # Make sure the model file has been autogenerated. Note that this causes a circular
                # dependency loop if shallow_load is not set to True in the generator
                # for the packet type.
                redo.redo_ifchange(model_path)

                # Now replace the packet by a new packet with the autogenerated type.
                self.entities[key] = packet(
                    name=pkt.name,
                    type=model_name + ".T",
                    description=pkt.description,
                    id=pkt.id,
                    suite=pkt.suite,
                )

                # Let's also add the type to our suite and component's complex types:
                self.type_models.append(self.entities[key].type_model)
                self.component.complex_types[
                    self.entities[key].type_model.name
                ] = self.entities[key].type_model

        # Call the base class version:
        super(cpu_monitor_packets, self).set_assembly(assembly)