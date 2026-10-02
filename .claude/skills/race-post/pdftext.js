// Usage: osascript -l JavaScript pdftext.js FILE.pdf </dev/null
// Prints the PDF's text. PDFKit is the only PDF reader on this Mac.
ObjC.import('PDFKit');
function run(argv) {
  const d = $.PDFDocument.alloc.initWithURL($.NSURL.fileURLWithPath(argv[0]));
  return (!d || d.isNil()) ? "UNREADABLE" : ObjC.unwrap(d.string);
}
