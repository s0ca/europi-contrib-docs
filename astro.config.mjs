import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://s0ca.github.io',
  base: '/europi-contrib-docs',
  integrations: [
    starlight({
      title: 'EuroPi Contrib Docs',
      description: 'Documentation for community EuroPi scripts.',
      defaultLocale: 'en',
      components: {
        Footer: './src/components/StickyFooter.astro',
      },
      customCss: ['./src/styles/custom.css'],
      head: [],
      social: [
        {
          icon: 'github',
          label: 'GitHub',
          href: 'https://github.com/Allen-Synthesis/EuroPi',
        },
      ],
      sidebar: [
      {
            "label": "Start here",
            "items": [
                  {
                        "label": "Overview",
                        "link": "/"
                  }
            ]
      },
      {
            "label": "Guides",
            "items": [
                  {
                        "label": "Arp",
                        "link": "/arp/"
                  },
                  {
                        "label": "Bernoulli Gates",
                        "link": "/bernoulli_gates/"
                  },
                  {
                        "label": "Bezier",
                        "link": "/bezier/"
                  },
                  {
                        "label": "Binary Counter",
                        "link": "/binary_counter/"
                  },
                  {
                        "label": "Bit Garden",
                        "link": "/bit_garden/"
                  },
                  {
                        "label": "Bouncing Pixels",
                        "link": "/bouncing_pixels/"
                  },
                  {
                        "label": "Clock Mod",
                        "link": "/clock_mod/"
                  },
                  {
                        "label": "Coin Toss",
                        "link": "/coin_toss/"
                  },
                  {
                        "label": "Consequencer",
                        "link": "/consequencer/"
                  },
                  {
                        "label": "Conway",
                        "link": "/conway/"
                  },
                  {
                        "label": "Cvecorder",
                        "link": "/cvecorder/"
                  },
                  {
                        "label": "Daily Random",
                        "link": "/daily_random/"
                  },
                  {
                        "label": "Dfam",
                        "link": "/dfam/"
                  },
                  {
                        "label": "Dscn2",
                        "link": "/dscn2/"
                  },
                  {
                        "label": "Egressus Melodiam",
                        "link": "/egressus_melodiam/"
                  },
                  {
                        "label": "Envelope Generator",
                        "link": "/envelope_generator/"
                  },
                  {
                        "label": "Euclid",
                        "link": "/euclid/"
                  },
                  {
                        "label": "Gate Phaser",
                        "link": "/gate_phaser/"
                  },
                  {
                        "label": "Gates And Triggers",
                        "link": "/gates_and_triggers/"
                  },
                  {
                        "label": "Hamlet",
                        "link": "/hamlet/"
                  },
                  {
                        "label": "Harmonic Lfos",
                        "link": "/harmonic_lfos/"
                  },
                  {
                        "label": "Http Control",
                        "link": "/http_control/"
                  },
                  {
                        "label": "Itty Bitty",
                        "link": "/itty_bitty/"
                  },
                  {
                        "label": "Kompari",
                        "link": "/kompari/"
                  },
                  {
                        "label": "Logic",
                        "link": "/logic/"
                  },
                  {
                        "label": "Lutra",
                        "link": "/lutra/"
                  },
                  {
                        "label": "Master Clock",
                        "link": "/master_clock/"
                  },
                  {
                        "label": "Menu",
                        "link": "/menu/"
                  },
                  {
                        "label": "Morse",
                        "link": "/morse/"
                  },
                  {
                        "label": "Noddy Holder",
                        "link": "/noddy_holder/"
                  },
                  {
                        "label": "Ocean Surge",
                        "link": "/ocean_surge/"
                  },
                  {
                        "label": "Osc Control",
                        "link": "/osc_control/"
                  },
                  {
                        "label": "Pams",
                        "link": "/pams/"
                  },
                  {
                        "label": "Particle Physics",
                        "link": "/particle_physics/"
                  },
                  {
                        "label": "Pet Rock",
                        "link": "/pet_rock/"
                  },
                  {
                        "label": "Piconacci",
                        "link": "/piconacci/"
                  },
                  {
                        "label": "Poly Square",
                        "link": "/poly_square/"
                  },
                  {
                        "label": "Probapoly",
                        "link": "/probapoly/"
                  },
                  {
                        "label": "Quantizer",
                        "link": "/quantizer/"
                  },
                  {
                        "label": "Radio Scanner",
                        "link": "/radio_scanner/"
                  },
                  {
                        "label": "Sequential Switch",
                        "link": "/sequential_switch/"
                  },
                  {
                        "label": "Sigma",
                        "link": "/sigma/"
                  },
                  {
                        "label": "Slopes",
                        "link": "/slopes/"
                  },
                  {
                        "label": "Strange Attractor",
                        "link": "/strange_attractor/"
                  },
                  {
                        "label": "Traffic",
                        "link": "/traffic/"
                  },
                  {
                        "label": "Turing Machine",
                        "link": "/turing_machine/"
                  },
                  {
                        "label": "Volts",
                        "link": "/volts/"
                  }
            ]
      },
      {
            "label": "Source code",
            "collapsed": true,
            "items": [
                  {
                        "label": "arp",
                        "link": "/code/arp/"
                  },
                  {
                        "label": "bernoulli_gates",
                        "link": "/code/bernoulli_gates/"
                  },
                  {
                        "label": "bezier",
                        "link": "/code/bezier/"
                  },
                  {
                        "label": "binary_counter",
                        "link": "/code/binary_counter/"
                  },
                  {
                        "label": "bit_garden",
                        "link": "/code/bit_garden/"
                  },
                  {
                        "label": "bouncing_pixels",
                        "link": "/code/bouncing_pixels/"
                  },
                  {
                        "label": "clock_mod",
                        "link": "/code/clock_mod/"
                  },
                  {
                        "label": "coin_toss",
                        "link": "/code/coin_toss/"
                  },
                  {
                        "label": "consequencer",
                        "link": "/code/consequencer/"
                  },
                  {
                        "label": "conway",
                        "link": "/code/conway/"
                  },
                  {
                        "label": "custom_font_demo",
                        "link": "/code/custom_font_demo/"
                  },
                  {
                        "label": "cvecorder",
                        "link": "/code/cvecorder/"
                  },
                  {
                        "label": "daily_random",
                        "link": "/code/daily_random/"
                  },
                  {
                        "label": "dfam",
                        "link": "/code/dfam/"
                  },
                  {
                        "label": "dscn2",
                        "link": "/code/dscn2/"
                  },
                  {
                        "label": "egressus_melodiam",
                        "link": "/code/egressus_melodiam/"
                  },
                  {
                        "label": "envelope_generator",
                        "link": "/code/envelope_generator/"
                  },
                  {
                        "label": "euclid",
                        "link": "/code/euclid/"
                  },
                  {
                        "label": "gate_phaser",
                        "link": "/code/gate_phaser/"
                  },
                  {
                        "label": "gates_and_triggers",
                        "link": "/code/gates_and_triggers/"
                  },
                  {
                        "label": "hamlet",
                        "link": "/code/hamlet/"
                  },
                  {
                        "label": "harmonic_lfos",
                        "link": "/code/harmonic_lfos/"
                  },
                  {
                        "label": "hello_world",
                        "link": "/code/hello_world/"
                  },
                  {
                        "label": "http_control",
                        "link": "/code/http_control/"
                  },
                  {
                        "label": "itty_bitty",
                        "link": "/code/itty_bitty/"
                  },
                  {
                        "label": "knob_playground",
                        "link": "/code/knob_playground/"
                  },
                  {
                        "label": "kompari",
                        "link": "/code/kompari/"
                  },
                  {
                        "label": "logic",
                        "link": "/code/logic/"
                  },
                  {
                        "label": "lutra",
                        "link": "/code/lutra/"
                  },
                  {
                        "label": "master_clock",
                        "link": "/code/master_clock/"
                  },
                  {
                        "label": "menu",
                        "link": "/code/menu/"
                  },
                  {
                        "label": "morse",
                        "link": "/code/morse/"
                  },
                  {
                        "label": "noddy_holder",
                        "link": "/code/noddy_holder/"
                  },
                  {
                        "label": "ocean_surge",
                        "link": "/code/ocean_surge/"
                  },
                  {
                        "label": "osc_control",
                        "link": "/code/osc_control/"
                  },
                  {
                        "label": "pams",
                        "link": "/code/pams/"
                  },
                  {
                        "label": "particle_physics",
                        "link": "/code/particle_physics/"
                  },
                  {
                        "label": "pet_rock",
                        "link": "/code/pet_rock/"
                  },
                  {
                        "label": "piconacci",
                        "link": "/code/piconacci/"
                  },
                  {
                        "label": "poly_square",
                        "link": "/code/poly_square/"
                  },
                  {
                        "label": "polyrhythmic_sequencer",
                        "link": "/code/polyrhythmic_sequencer/"
                  },
                  {
                        "label": "probapoly",
                        "link": "/code/probapoly/"
                  },
                  {
                        "label": "quantizer",
                        "link": "/code/quantizer/"
                  },
                  {
                        "label": "radio_scanner",
                        "link": "/code/radio_scanner/"
                  },
                  {
                        "label": "scope",
                        "link": "/code/scope/"
                  },
                  {
                        "label": "sequential_switch",
                        "link": "/code/sequential_switch/"
                  },
                  {
                        "label": "settings_menu_example",
                        "link": "/code/settings_menu_example/"
                  },
                  {
                        "label": "sigma",
                        "link": "/code/sigma/"
                  },
                  {
                        "label": "slopes",
                        "link": "/code/slopes/"
                  },
                  {
                        "label": "smooth_random_voltages",
                        "link": "/code/smooth_random_voltages/"
                  },
                  {
                        "label": "strange_attractor",
                        "link": "/code/strange_attractor/"
                  },
                  {
                        "label": "traffic",
                        "link": "/code/traffic/"
                  },
                  {
                        "label": "turing_machine",
                        "link": "/code/turing_machine/"
                  },
                  {
                        "label": "volts",
                        "link": "/code/volts/"
                  }
            ]
      }
]
    })
  ],
});
