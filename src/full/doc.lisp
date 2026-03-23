(in-package :dref)

(defun dref-sections ()
  (list @dref-manual))

(defun dref-pages ()
  `((:objects
     (, @dref-manual)
     :source-uri-fn ,(make-github-source-uri-fn
                      "dref" "https://github.com/melisgl/dref"))))

(register-doc-in-pax-world :dref 'dref-sections 'dref-pages)


(defun dref-pages* (format &key (output-dir ""))
  (let ((source-uri-fn (make-git-source-uri-fn
                        "dref" "https://github.com/melisgl/dref"))
        (file (ecase format
                ((:plain) "README")
                ((:markdown) "README.md")
                ((:html) "dref-manual.html")
                ((:pdf) "dref-manual.pdf")))
        (output-dir (asdf:system-relative-pathname "dref" output-dir)))
    `((:objects (, @dref-manual)
       :output (,(merge-pathnames file output-dir)
                :if-does-not-exist :create
                :if-exists :supersede
                :ensure-directories-exist t)
       ,@(when (eq format :markdown)
           '(:header-fn print-dref-markdown-header))
       ,@(when (member format '(:plain :markdown))
           '(:footer-fn pax::print-markdown-footer))
       :source-uri-fn ,source-uri-fn))))

(defun print-dref-markdown-header (stream)
  (format stream "![](src/dref-logo.jpg)~%~%"))

(defun update-dref-readmes (&key (output-dir ""))
  ;; Most PAX symbols that we use are from mgl-pax-bootstrap, but
  ;; PAX:DOCUMENT and PAX:*DOCUMENT-URL-VERSIONS* are not. Normally,
  ;; PAX's loaddefs.lisp exports these symbols. However, when
  ;; (AUTOLOAD:RECORD-AUTOLOADS "MGL-PAX") is run, PAX's
  ;; autoloads.lisp is emptied, and these symbols are only exported in
  ;; mgl-pax/document. Since mgl-pax/document (indirectly) depends on
  ;; dref/full, we would get a symbol conflict if we didn't qualify
  ;; their names with the PAX:: prefix.
  (let ((pax::*document-url-versions* '(1)))
    (declare (special pax::*document-url-versions*))
    (pax::document (dref-sections)
                   :pages (dref-pages* :plain :output-dir output-dir)
                   :format :plain)
    (pax::document (dref-sections)
                   :pages (dref-pages* :markdown :output-dir output-dir)
                   :format :markdown)))


#+nil
(progn
  (asdf:load-system :dref/full)
  (time (update-dref-readmes)))
