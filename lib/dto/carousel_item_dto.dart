class CarouselItemDTO {
  final String image;
  final String title;
  final String description;

  CarouselItemDTO(
      {required this.image, required this.title, required this.description});
}

final items = [
  CarouselItemDTO(
    image: 'assets/images/helper-1.svg',
    title: 'Estás más cerca.',
    description:
        'Ahora darás seguimiento a las citas y procedimientos realizados a tus mascotas.',
  ),
  CarouselItemDTO(
    image: 'assets/images/helper-2.svg',
    title: 'Conecta más.',
    description:
        'Puedes buscar los centros más cercanos por sus servicios ofrecidos y sus especialidades.',
  ),
  CarouselItemDTO(
    image: 'assets/images/helper-3.svg',
    title: 'Escuchamos tu opinión.',
    description:
        'Tenemos un espacio de sugerencias y valoración de nuestros centros veterinarios.',
  ),
];
