def slugify(text):
    text = text.lower().strip()
    text = text.replace(" ", "-")
    return text
