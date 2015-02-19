#/usr/bin/env python

import os
import re

# Class to define the anatomy of an app
class Anatomy(object):

    # return a list of files (in order) representing the design spec
    def design_file_list(self):
        return []

    # return a list of files (no order) representing a specific implementation (e.g. screenshots)
    def screenshot_file_list(self, target, version):
        return []

    # return a list of 2-tuples (in order) representing the target/version combinations that should be evaluated
    def target_version_list(self):
        return []

    # list of all attributes
    def all_target_attributes(self):
        return []

    # return the (string) attribute for a specific target
    def attribute_of_target(self, target):
        return ""


# Class to get the anatomy of an app via some filesystem conventions
class FilesystemAnatomy(Anatomy):

    def __init__(self):
        self.design_directory = ""
        self.design_file_static_list = None
        self.design_ignorelist = []
        self.screenshot_root_directory = ""
        self.attribute_of_target_fn = None
        self.all_attributes_of_targets = []

    def set_design_directory(self, directory):
        self.design_directory = os.path.abspath(directory)

    def set_design_file_list_from_file(self, textfile):
        with open(textfile) as f:
            self.design_file_static_list = [os.path.abspath(line.strip()) for line in f.readlines() if line.strip()]
            f.close()

    def set_screenshot_root_directory(self, directory):
        self.screenshot_root_directory = os.path.abspath(directory)

    def set_ignorelist_from_file(self, textfile):
        with open(textfile) as f:
            self.design_ignorelist = [os.path.abspath(line.strip()) for line in f.readlines() if line.strip()]
            f.close()

    def set_attribute_of_target_fn(self, fn):
        self.attribute_of_target_fn = fn

    def set_all_attributes_of_targets(self, alist):
        self.all_attributes_of_targets = alist


    # get the list of files from a directory, minus any names in an ignore list
    def design_file_list(self):

        if self.design_file_static_list is not None: return self.design_file_static_list

        # for each filename in master directory - alphabetical:
        #  add image files if file is not in ignore list
        ret = []

        for f in self.walk_1(self.design_directory)[2]:
            if os.path.splitext(f)[1].upper() in [".PNG", ".JPG"] and f not in self.design_ignorelist:
                ret.append(os.path.join(self.design_directory, f))

        return sorted(ret, cmp=self.versioned_compare)


    # get a list of pairs of target/version in the image directory
    # we assume a structure of root -> target -> version
    def target_version_list(self):
        ret = []
        for target in self.walk_1(self.screenshot_root_directory)[1]:
            for version in self.walk_1(os.path.join(self.screenshot_root_directory, target))[1]:
                ret.append((target, version))

        return ret

    # get a list of all the screenshots in a target/version directory
    def screenshot_file_list(self, target, version):
        shot_dir = os.path.join(self.screenshot_root_directory, target, version)
        return [os.path.join(shot_dir, f) for f in self.walk_1(shot_dir)[2]]


    def attribute_of_target(self, target):
        assert self.attribute_of_target_fn is not None, "must set attribute_of_target function with set_attribute_of_target_fn()"
        return self.attribute_of_target_fn(target)

    def all_target_attributes(self):
        return self.all_attributes_of_targets


    # os.walk one directory only
    def walk_1(self, directory):
        assert os.path.exists(directory)
        for (dirpath, dirnames, filenames) in os.walk(directory):
            return (dirpath, dirnames, filenames) #intentionaly return after top-level dir walk

    # compare filenames in the form "1.4.2 something something.png"
    def versioned_compare(self, caption1, caption2):
        ok = re.compile("[0-9.]+[^0-9.]+")
        if None is ok.match(caption1) or None is ok.match(caption2):
            text1 = caption1
            text2 = caption2
        else:
            dotted = re.compile("[^0-9.]")
            dots1, text1 = dotted.split(caption1, 1)
            dots2, text2 = dotted.split(caption2, 1)

            v1 = [int(x) for x in dots1.split(".") if x != ""]
            v2 = [int(x) for x in dots2.split(".") if x != ""]

            for i in range(max(len(v1), len(v2))):
                if len(v1) != len(v2):
                    if i >= len(v1): return -1
                    if i >= len(v2): return 1
                if v1[i] != v2[i]: return v1[i] - v2[i]

        # fall back on text compare
        if text1 < text2: return -1
        if text1 > text2: return 1
        return 0
