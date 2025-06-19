// Estructura de datos para un libro con sus capítulos
final List<Map<String, dynamic>> seedBooksData = [
  // --- Libro 1 ---
  {
    'id': 'cien-anos-de-soledad',
    'title': 'Cien Años de Soledad',
    'author': 'Gabriel García Márquez',
    'coverUrl': 'https://images.penguinrandomhouse.com/cover/9780525562443',
    'description':
        'La novela narra la historia de la familia Buendía a lo largo de siete generaciones en el pueblo ficticio de Macondo.',
    'chapters': [
      {
        'id': 'cas-capitulo-1',
        'title': 'Capítulo 1: El Descubrimiento del Hielo',
        'synopsis': 'Una descripción detallada del primer capítulo...',
        'pageCount': 20,
        'pdfUrl':
            'https://vyqsylsofvukthfdantr.supabase.co/storage/v1/object/public/archivos-amicana/pdf_caps/chapter%201%20-.pdf',
        'audioUrl': 'https://open.spotify.com/track/1XwRyFRn2qU6phLtOQ53MI'
      },
      {
        'id': 'cas-capitulo-2',
        'title': 'Capítulo 2: Los Pergaminos de Melquíades',
        'synopsis':
            'José Arcadio Buendía se obsesiona con descifrar los pergaminos...',
        'pageCount': 25,
        'pdfUrl':
            'https://vyqsylsofvukthfdantr.supabase.co/storage/v1/object/public/archivos-amicana/pdf_caps/CHAPTER%202.pdf',
        'audioUrl':
            'https://open.spotify.com/track/2k5qBSP7L76HxUFefb75q6' // Dejar vacío si no hay
      }
    ]
  }, // <-- Coma que separa los libros

  // --- Libro 2 ---
  {
    'id': 'the-scarlet-letter',
    'title': 'The Scarlet Letter',
    'author': 'Nathaniel Hawthorne',
    'coverUrl': '',
    'description':
        'Una historia de Hester Prynne, quien concibe una hija a través de un romance y lucha por crear una nueva vida de arrepentimiento y dignidad.',
    'chapters': [
      {
        'id': 'tsl-capitulo-1',
        'title': 'Chapter 1: The Prison-Door',
        'pageCount': 5,
        'synopsis': '''
A crowd of men and women assembles near a dilapidated wooden prison. The narrator remarks that the founders of every new settlement have always sought first to build a prison and a graveyard. He adds that this particular prison was most likely built upon the founding of Boston and describes prisons as the "black flower of civilized society."
Next to the prison door stands a blooming wild rose bush. The narrator imagines that perhaps the rose bush grows in such an unlikely place to offer comfort to prisoners entering the jail and forgiveness from Nature to those leaving it to die on the scaffold.
The narrator describes the rose bush as sitting on the threshold of the story he plans to tell. He then plucks one of the rose blossoms and offers it to the reader. He describes the gesture and the blossom as a symbol of the moral that the reader might learn in reading his "tale of human frailty and sorrow."
''',
        'pdfUrl':
            'https://vyqsylsofvukthfdantr.supabase.co/storage/v1/object/public/archivos-amicana/pdf_caps/chapter%201%20-.pdf',
        'audioUrl': 'https://open.spotify.com/track/1XwRyFRn2qU6phLtOQ53MI'
      },
      {
        'id': 'tsl-capitulo-2',
        'title':
            'Chapter 2: The Market-Place', // Título corregido para que coincida con la sinopsis
        'synopsis': '''
The crowd outside the prison grows restless waiting for Hester Prynne to appear. The faces in the crowd are grim, yet familiar, since Puritans gathered often to watch criminals be punished. The narrator says that the Puritans considered religion and law to be almost identical.
Puritans, like the prison, are supposed to hate sin, but seem to thrive on it. They gather with a kind of grim fascination to watch sinners get punished and even executed.
Some of the Puritan women waiting outside the prison say Hester deserved a harsher sentence. One states that Revered Dimmesdale, Hester's pastor, must be ashamed that a member of his congregation committed such an awful sin. Another says that Hester should have been executed for her sin.
The comments about Hester paint the Puritans as cold and harsh. The mention of Dimmesdale's shame foreshadows his association with Hester and her crime.
Hester exits the prison holding a three month-old infant. The prison guard puts a hand on her shoulder, but she shrugs him off and goes out alone, with "natural dignity," looking proud, radiant, and beautiful.
''',
        'pageCount': 25,
        'pdfUrl':
            'https://vyqsylsofvukthfdantr.supabase.co/storage/v1/object/public/archivos-amicana/pdf_caps/CHAPTER%202.pdf',
        'audioUrl': 'https://open.spotify.com/track/2k5qBSP7L76HxUFefb75q6'
      }
    ]
  }
]; // <-- PUNTO Y COMA CORREGIDO, AHORA ESTÁ AL FINAL DE TODA LA LISTA
