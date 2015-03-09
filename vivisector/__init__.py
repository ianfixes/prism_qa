#!/usr/bin/env python

"""Vivisector is a tool for comparing design spec images with various implementation images"""

import os
from report import ReportWriter
from image import DesignBank, ScreenshotBank


__version__ = '0.1.0'


def vivisect(anatomy, report_writer):

    # name of a screenshot set
    def name_of_set(target, version):
        return "%s, %s" % (target, version)

    # make design bank
    design_bank = DesignBank(anatomy.design_file_list())

    # make screenshot banks
    screenshot_banks = {}
    for (target, version) in anatomy.target_version_list():
        image_list = anatomy.screenshot_file_list(target, version)
        screenshot_banks[name_of_set(target, version)] = ScreenshotBank(anatomy.screenshot_file_list(target, version),
                                                                        anatomy.attribute_of_target(target))

    # iterate over screenshot attributes
    for attribute in anatomy.all_target_attributes():
        report_name = attribute + "-screenshots"
        report_matched_sets = []
        valid_design_files = [d for d in anatomy.design_file_list() if design_bank.image_valid_for_attribute(d, attribute)]

        # create a row for each design image followed by matching screenshots
        for design_image in valid_design_files:
            print attribute, "\t", os.path.basename(design_image)
            matched_set = [(os.path.basename(design_image), "Design", design_image)]

            shot_set = []
            # iterate over targets that are valid for this screenshot attribute
            for (target, version) in anatomy.target_version_list():
                if not anatomy.attribute_of_target(target) == attribute: continue
                setname = name_of_set(target, version)
                screenshot_bank = screenshot_banks[setname]

                design_data = design_bank.image_data[design_image]
                shot = screenshot_bank.get_best_image_for(design_data.get("section"),
                                                          design_data.get("screen"),
                                                          design_data.get("scenario"),
                                                          attribute,
                                                          design_data.get("variant"))

                if shot:
                    print "\t", name_of_set(target, version), "\t", os.path.basename(shot)

                shot_set.append((design_image, setname, shot))

            shot_set.reverse()
            report_matched_sets.append(matched_set + shot_set)

        report_writer.process(report_name, report_matched_sets)
