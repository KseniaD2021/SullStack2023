import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Product{
	@PrimaryGeneratedColumn()
	public id!: number;

	@Column()
	public title: string;

	@Column()
	public department: string;

	@Column()
	public price: number;

	@Column("text", { array: true })
	images: string[];

	@Column()
	public preview: string;

	@Column()
	public description: string;

	@Column()
	public details: string;

	@Column()
	public bagde: string;

	@Column()
	public bagdeColor: string;

	@Column()
	public sizeValue: string;

	@Column()
	public isAvaliableSize: boolean;
}
