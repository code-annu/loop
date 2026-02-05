/**
 * Artist Domain Entity
 */
export interface Artist {
  id: string;
  name: string;
  profileUrl: string | null;
}

export class ArtistEntity implements Artist {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly profileUrl: string | null,
  ) {}

  static create(props: Artist): ArtistEntity {
    return new ArtistEntity(props.id, props.name, props.profileUrl);
  }
}
