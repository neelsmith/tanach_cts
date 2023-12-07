# Download text files from tanach.us
using Downloads
using HTTP

# File locations
outdir = joinpath(pwd(), "textsrc")
baseurl = "https://tanach.us/Server.txt?"

# Keys of tanach.us file names to local file name to use
books = Dict([
    ("Gen", "genesis"),
    ("Ex", "exodus"),
    ("Lev", "leviticus"),
    ("Num", "numbers"),
    ("Deut", "deuteronomy"),
    ("Josh", "joshua"),
    ("Judg", "judges"),
    ("1 Sam", "samuel1"),
    ("2 Sam", "samuel2"),
    ("1 Kings", "kings1"),
    ("2 Kings", "kings2"),
    ("Isa", "isaiah"),
    ("Jer", "jeremiah"),
    ("Ezek", "ezekiel"),

    ("Hos", "hosea"),
    ("Joel", "joel"),
    ("Am", "amos"),
    ("Ob", "obadiah"),
    ("Jon", "jonah"),
    ("Mic", "micah"),
    ("Nah", "nahum"),
    ("Hab", "habakkuk"),
    ("Zeph", "zephaniah"),
    ("Hag", "haggai"),
    ("Zech", "zechariah"),
    ("Mal", "malachi"),

    ("Ps", "psalms"),
    ("Prov", "proverbs"),
    ("Job", "job"),
    ("Song", "songs"),
    ("Ruth", "ruth"),
    ("Lam", "lamentations"),
    ("Eccl", "ecclesiastes"),
    ("Esth", "esther"),
    ("Dan", "daniel"),
    ("Ezra", "ezra"),
    ("Neh", "nehemiah"),
    ("1 Chr", "chronicles2"),
    ("2 Chr", "chronicles2")


    ]
)

bklist = keys(books) |> collect

@info("Looking for $(length(bklist)) books:")
for b in bklist #keys(books)
    @info("=> Look for key $(b)")
    url = string(baseurl, HTTP.escapeuri(b), "*")
    dlfile = Downloads.download(url)
    @info("Downloaded $(url)")
    outfile = joinpath(outdir, string(books[b], ".txt"))
    open(outfile,"w") do io
        write(outfile, read(dlfile, String))
    end
    @info("Wrote to $(outfile)")
    rm(dlfile)
end