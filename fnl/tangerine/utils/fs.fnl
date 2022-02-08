(local fs {})

;; -------------------- ;;
;;      Directory       ;;
;; -------------------- ;;
(lambda fs.mkdir [path]
  (vim.fn.mkdir path :p))

;; -------------------- ;;
;;        Files         ;;
;; -------------------- ;;
(lambda fs.readable? [path]
  (= 1 (vim.fn.filereadable path)))

(lambda fs.read [path]
  (with-open [file (assert (io.open path :r))]
             (file:read "*a")))

(lambda fs.write [path content]
  (let [dir (fs.dirname path)]
    (if (not (fs.dir-exists? dir))
        (fs.mkdir dir))
    (with-open [file (assert (io.open path :w))]
               (file:write content))))

(lambda fs.remove [path]
  (os.remove path))

:return fs
