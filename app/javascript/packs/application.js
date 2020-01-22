/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// console.log('Hello World from Webpacker')
import "core-js/stable";
import "regenerator-runtime/runtime";

document.addEventListener('turbolinks:load', () => {
  ClassicEditor.create(document.querySelector('.editor'), {
    simpleUpload: {
      uploadUrl: '/uploads',
      headers: {
        'X-CSRF-TOKEN': document.querySelector( 'meta[name=\'csrf-token\']' ).getAttribute( 'content' ),
      }
    },
     fontColor: {
            colors: [
                {
                    color: 'hsl(0, 0%, 0%)',
                    label: 'Black'
                },
                {
                    color: 'hsl(0, 0%, 30%)',
                    label: 'Dim grey'
                },
                {
                    color: 'hsl(0, 0%, 60%)',
                    label: 'Grey'
                },
                {
                    color: 'hsl(0, 0%, 90%)',
                    label: 'Light grey'
                },
                {
                    color: 'hsl(0, 75%, 60%)',
                    label: 'red'
                },
                {
                    color: 'hsl(30, 75%, 60%)',
                    label: 'orange'
                },
                {
                    color: 'hsl(60, 75%, 60%)',
                    label: 'yellow'
                },
                {
                    color: 'hsl(90, 75%, 60%)',
                    label: 'light green'
                },
                {
                    color: 'hsl(120, 75%, 60%)',
                    label: 'green'
                },
                {
                    color: 'hsl(0, 0%, 100%)',
                    label: 'White',
                    hasBorder: true
                },

                // ...
            ]
        },
        fontBackgroundColor: {
            colors: [
                {
                    color: 'hsl(0, 75%, 60%)',
                    label: 'red'
                },
                {
                    color: 'hsl(30, 75%, 60%)',
                    label: 'orange'
                },
                {
                    color: 'hsl(60, 75%, 60%)',
                    label: 'yellow'
                },
                {
                    color: 'hsl(90, 75%, 60%)',
                    label: 'light green'
                },
                {
                    color: 'hsl(120, 75%, 60%)',
                    label: 'green'
                },

                // ...
            ]
        },
    toolbar: {
items: [
						'heading',
						'|',
						'fontSize',
						'fontFamily',
            'fontColor',
            'fontBackgroundColor',
						'highlight',
						'bold',
						'italic',
						'underline',
						'removeFormat',
						'link',
						'bulletedList',
						'numberedList',
						'|',
						'alignment',
						'indent',
						'outdent',
						'|',
						'imageUpload',
						'mediaEmbed',
						'insertTable',
						'blockQuote',
						'code',
						'codeBlock',
						'horizontalLine',
						'undo',
						'redo'
					]
				},
				language: 'ru',
				image: {
          styles: [
                // This option is equal to a situation where no style is applied.
                'full',

                // This represents an image aligned to the left.
                'alignLeft',

                // This represents an image aligned to the right.
                'alignRight'
            ],
          toolbar: [ 'imageTextAlternative', '|', 'imageStyle:alignLeft', 'imageStyle:full', 'imageStyle:alignRight' ]
				},
				table: {
					contentToolbar: [
						'tableColumn',
						'tableRow',
						'mergeTableCells'
					]
				}
  })
})
