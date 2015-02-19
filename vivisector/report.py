#/usr/bin/env python

import os
import urllib


class ReportWriter(object):

    def __init__(self):
        self.titlePrefix = "Vivisector report for"
        self.masterCssClass = "masterimg"
        self.holderCssClass = "holder"
        self.extraCss = ""

    def filename_of_report(self, report_name):
        return "%s.html" % report_name

    def process(self, report_name, matched_sets):
        filename = self.filename_of_report(report_name)
        print filename
        title = "%s %s" % (self.titlePrefix, report_name)
        out_html = ""
        out_html += "<html>\n<head>\n"
        out_html += "<title>%s</title>\n" % title
        out_html += "<style type='text/css'>\n"

        out_html += "body {color:white; background-color:#333;}\n"
        out_html += "th {border-top: 1px solid #ccc;}\n"
        out_html += "td {padding-bottom:1ex;}\n"
        out_html += ".masterimg {background-color:white;}\n"
        out_html += ".missing {white-space: pre; text-align:center;}\n"

        out_html += self.extraCss

        out_html += "</style>\n"
        out_html += "</head>\n"
        out_html += "<body>\n"

        out_html += "<h1>%s</h1>\n" % title

        if 0 == len(matched_sets):
            out_html += "No input images were found"
        else:
            out_html += "<table class='comparison'>\n"
            out_html += " <tr>\n"
            for (_, target, __) in matched_sets[0]:
                out_html += "  <td align='center'>%s</td>\n" % target
            out_html += " </tr>\n"

            for row in matched_sets:
                (_, __, img_master) = row[0]
                img_actual = row[1:]
                out_html += " <tr>\n"
                base = os.path.basename(img_master)
                out_html += "  <th colspan='%d'><a name='%s'>%s</a></th>\n" % (len(row), urllib.quote(base), base)
                out_html += " </tr>\n"
                out_html += " <tr>\n"
                out_html += "  <td align='right' valign='top'>"
                out_html +=    "<img class='masterimg' src='file://%s' alt='%s' /></td>\n" % (img_master, base)

                for (design_image, target, img) in img_actual:
                    if img is None:
                        out_html += "  <td><div class='missing'>%s\non %s</div></td>\n" % (design_image, target)
                    else:
                        out_html += "  <td align='left' valign='top'>"
                        out_html +=    "<div class='%s'><img src='file://%s' class='ipad' alt='%s' /></div></td>\n" % (self.holderCssClass, img, img)
                out_html += " </tr>\n"
            out_html += "</table>"

        out_html += "</body></html>"

        with open(filename, "w") as text_file:
            text_file.write(out_html)
