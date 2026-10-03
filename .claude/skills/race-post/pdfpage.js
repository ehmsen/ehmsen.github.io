// Usage: osascript -l JavaScript pdfpage.js IN.pdf NAME OUT.pdf </dev/null
// Saves the first page of IN.pdf whose text contains NAME as OUT.pdf.
// For a shared diploma PDF with one page per runner.
ObjC.import('PDFKit');
function run(argv) {
  const src = $.PDFDocument.alloc.initWithURL($.NSURL.fileURLWithPath(argv[0]));
  for (let i = 0; i < src.pageCount; i++) {
    const page = src.pageAtIndex(i);
    if ((ObjC.unwrap(page.string) || '').indexOf(argv[1]) >= 0) {
      const out = $.PDFDocument.alloc.init;
      out.insertPageAtIndex(page, 0);
      return out.writeToFile(argv[2]) ? 'page ' + (i + 1) + ' of ' + src.pageCount : 'WRITE FAILED';
    }
  }
  return 'NOT FOUND';
}
