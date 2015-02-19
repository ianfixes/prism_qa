#/usr/bin/env python

import os

class ImageBank(object):

    def __init__(self, file_list):
        self.image_data = self.make_image_data(file_list)
        self.attributes = set([data["attribute"] for data in self.image_data.values() if "attribute" in data])
        self.image_data_lookup = self.make_image_lookup(self.image_data)
        self.image_order = [f for f in file_list if f in self.image_data] # preserve input list order

    def make_image_data(self, file_list):
        raise NotImplementedError

    # get the list of files in this bank
    def files(self):
        return self.image_order[:]

    # make a key into the lookup array
    def make_key_for(self, section, screen, scenario, attribute=None, variant=None):
        data = [section, screen, scenario]
        if attribute is not None: data.append(attribute)
        if variant is not None: data.append(variant)
        return ".".join(data)

    # get an image based on criteria, or None
    def get_exact_image_for(self, section, screen, scenario, attribute=None, variant=None):
        return self.image_data_lookup.get(self.make_key_for(section, screen, scenario, attribute, variant))

    # make a lookup array based on input data
    def make_image_lookup(self, image_data):
        ret = {}
        for (name, data) in image_data.iteritems():
            keys = [data["section"], data["screen"], data["scenario"]]
            if "attribute" in data:
                keys.append(data["attribute"])
                if "variant" in data:
                    keys.append(data["variant"])

            ret[".".join(keys)] = name

        return ret

    # parse a filename in the format:
    #   (section).(screen).(scenario)+(attribute).(variant)-(any-description).png
    def parse_filename(self, full_filename, output_field_labels):
        filename = os.path.basename(full_filename)

        # split stuff up
        # TODO: come on, use a library... this split op is bush league
        basename = filename[:-4]
        extension = filename[-4:]

        # basic assertions
        assert extension.upper() in [".PNG", ".JPG"], "Unrecognized file extension for " + filename
        if "+" in basename: assert "-" in filename, "This filename looks wrong for our format: " + filename

        # parse out a description if it exists
        if "-" not in basename:
            description = ""
            fields = basename.split(".")
        else:
            # split off the prefix from the description
            prefix, description = basename.split("-", 1)

            # split off the suffix and build fields
            suffix = ""
            if "+" not in description:
                fields = prefix.split(".")
            else:
                description, suffix = description.rsplit("+", 1)
                fields = (prefix + "." + suffix).split(".")

        # assert we got the main fields
        assert len(fields) > 2, "Couldn't parse section/screen/scenario (/attribute/variant) from " + filename

        return dict(zip(["description"] + output_field_labels,
                        [description] + fields))




class DesignBank(ImageBank):

    def __init__(self, file_list):
        ImageBank.__init__(self, file_list)

    def make_image_data(self, file_list):
        ret = {}
        for fullname in file_list:
            try:
                name = os.path.basename(fullname)
                ret[fullname] = self.parse_filename(name, ["section", "screen", "scenario", "attribute", "variant"])
            except AssertionError as a:
                print a
            except Exception as e:
                raise e

        return ret

    def image_valid_for_attribute(self, filename, attribute):
        # valid if a more specific image does not exist

        data = self.image_data[filename]


        # all other scenarios false


        if "attribute" not in data:
            # if this is general and no specific attribute exists, true
            specific_image = self.get_exact_image_for(data.get("section"),
                                                      data.get("screen"),
                                                      data.get("scenario"),
                                                      attribute,
                                                      data.get("variant"))
            if specific_image is None: return True

        else:
            # if this is specific and attribute is exact match, true
            if data["attribute"] == attribute: return True

            # if this is specific and attribute is wrong, but no correct attribute or general is defined, true
            general_image = self.get_exact_image_for(data.get("section"),
                                                     data.get("screen"),
                                                     data.get("scenario"),
                                                     None,
                                                     data.get("variant"))
            specific_images = [self.get_exact_image_for(data.get("section"),
                                                        data.get("screen"),
                                                        data.get("scenario"),
                                                        s,
                                                        data.get("variant")) for s in self.attributes if s != data["attribute"]]
            if all(map(lambda x: x is None, specific_images + [general_image])): return True

        return False


class ScreenshotBank(ImageBank):

    def __init__(self, file_list, screenshot_attribute):
        self.screenshot_attribute = screenshot_attribute
        ImageBank.__init__(self, file_list)

    def make_image_data(self, file_list):
        # pre-fill the screenshot attribute for this target
        ret = {}
        for fullname in file_list:
            try:
                name = os.path.basename(fullname)
                newval = self.parse_filename(name, ["section", "screen", "scenario", "variant"])
                newval["attribute"] = self.screenshot_attribute
                ret[fullname] = newval
            except AssertionError:
                pass
            except Exception as e:
                raise e

        return ret

    def get_best_image_for(self, section, screen, scenario, attribute=None, variant=None):
        # build possible scenarios -- note these are built in reverse order
        tries = [[section, screen, scenario]]
        if attribute is not None:
            tries = [[section, screen, scenario, attribute]] + tries
            if variant is not None:
                tries = [[section, screen, scenario, attribute, variant]] + tries

        for t in tries:
            key = ".".join(t)
            if key in self.image_data_lookup: return self.image_data_lookup[key]

        return None
