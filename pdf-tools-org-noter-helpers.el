;; Author: @analyticd
;; License MIT
;; Copyright (c) 2018 @analyticd
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;;###autoload
(defun org-noter-create-notes-file-for-current-book ()
  "Create the org-noter file based on the PDF file name for the current buffer."
  (interactive)
  (if (eq major-mode 'pdf-view-mode)    ; TODO This should be made to work with nov.el for epub books too.
      (progn
        (call-interactively 'bookmark-set)
        (save-excursion
          (let* ((book-filename buffer-file-name)
                 (filename-non-directory (file-name-nondirectory book-filename))
                 (filename (replace-regexp-in-string
                            " " "-"
                            (first (split-string filename-non-directory "\\\."))))
                 (noter-filepath (concatenate 'string org-directory "/" filename "-notes" ".org")))
            (with-temp-buffer (find-file noter-filepath)
                              (if (not (file-exists-p noter-filepath))
                                (delay-mode-hooks
                                  (point-min)
                                  (org-insert-heading)
                                  (insert (format " %s\n" filename))
                                  (org-set-property "NOTER_DOCUMENT" book-filename)
                                  (save-buffer))
                                (find-file noter-filepath))
                              (org-noter))
            (call-interactively 'bookmark-jump))))
    (error "Must be in \"PDFView\" mode to use this function.")))

(provide 'pdf-tools-org-noter-helpers)
