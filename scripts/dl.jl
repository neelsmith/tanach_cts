# Download text files from tanach.us
using Downloads

# File locations
outdir = joinpath(pwd(), "textsrc")
baseurl = "https://tanach.us/Server.txt?"

# Keys of tanach.us file names to local file name to use
books = Dict([
    ("Deut","deuteronomy")
    ]
)


for b in keys(books)
    url = string(baseurl, b, "*")
    dlfile = Downloads.download(url)
    @info("Downloaded $(url)")
    outfile = joinpath(outdir, string(books[b], ".txt"))
    open(outfile,"w") do io
        write(outfile, read(dlfile, String))
    end
    @info("Wrote to $(outfile)")
    rm(dlfile)
end