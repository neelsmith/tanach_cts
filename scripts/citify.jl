#=

=#

# Metadata characters we'll refer to by name:
pipe = '|'
colon = '׃'

# non-breaking space:
nbs = Char(0x000000a0)

# change RTL/LTR direction:
flip1 = Char(0x0000202b) 
flip2 = Char(0x0000202c)

"""Read tanach.us file from `infile`, convert to CEX format,
and write to `outfile`, using `workid` as work identifier in CTS URNs."""
function citify(infile, outfile, workid)
    rawlines = readlines(infile)

    striptrail = map(ln -> replace(ln, string(flip2) => ""), rawlines)
    striplead = map(ln -> replace(ln, string(flip1, nbs) => ""), striptrail)
    readablebreaks = map(s -> replace(s, nbs => "|"), striplead)

    seq = string(pipe, colon)
    chapterfy = map(ln -> replace(ln, seq => "."), readablebreaks)
    nopipes = map(ln -> replace(ln, "|" => ""), chapterfy)
    cexified = replace(ln -> replace(ln, r"^([0-9.]+)" => s"\1|"), nopipes)
    #dirty = filter(ln -> ! startswith(ln, r"[0-9]"), cexified)
    clean = filter(ln -> startswith(ln, r"[0-9]"), cexified)

    ubase = string("urn:cts:ns:tanach.", workid, ".omar:")
    cex = map(s -> string(ubase, s), clean)
    open(outfile, "w" ) do io
        write(io, "#!ctsdata\n" * join(cex, "\n"))
    end
end


srcdir = joinpath(pwd(), "textsrc")
cexdir = joinpath(pwd(), "cex")

txtlist = ["deuteronomy"]

for txt in txtlist
    srcfile = joinpath(srcdir, "$(txt).txt")
    outfile = joinpath(cexdir, "$(txt).cex")
    citify(srcfile, outfile, txt)
end